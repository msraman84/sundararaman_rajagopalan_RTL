`timescale 1ns/1ps
`include "lfsr_8bit.sv"
module rc5_enc_dec_param#(
	parameter int w = 16,		//Parameter for specifying data width
	parameter r = 3			//Parameter for specifying number of rounds
	)(
	input wire clock, 		//Clock input
	input wire reset, 		//Asynchronous reset input
	input wire enc_start, 		//When HIGH, /enc_start triggers the encryption process
	input wire dec_start, 		//When HIGH, dec_start triggers the encryption process
	input wire [7:0] lfsr_seed_enc,  	//8-bit input seed to be applied to LFSR for generating s-box keys for encryption
	input wire [7:0] lfsr_seed_dec,  	//8-bit input seed to be applied to LFSR for generating s-box keys for decryption
	input wire [w-1:0] p_in, 		//w-bit plaintext input
	input wire [w-1:0] c_in, 		//w-bit ciphertext input
	output reg [w-1:0] c_out, 		//w-bit ciphertext output
	output reg [w-1:0] p_out, 		//w-bit plaintext output
	output reg enc_done,		//Output to indicate the generation of final ciphertext
	output reg dec_done		//Output to indicate the generation of final plaintext
	); 			
	
	logic [7:0] s_enc[0:((2*r)+1)];	//S-box keys for encryption will be stored here
	logic [7:0] s_dec[0:((2*r)+1)];	//S-box keys for decryption will be stored here
	reg [w-1:0] p_tmp;		//Temporary register to handle internal encryption operation results
	reg [w-1:0] c_tmp;		//Temporary register to handle internal decryption operation results
	reg [2:0] state_enc; 		//FSM states for encryption are handled by this register
	reg [2:0] state_dec; 		//FSM states for decryption are handled by this register
	logic [7:0] lfsr_out_enc;		//LFSR output for encryption S-box keys
	logic [7:0] lfsr_out_dec;		//LFSR output for decryption S-box keys
	int cnt_g_enc;			//Count to handle the generation of number of encryption S-box keys
	int cnt_g_dec;			//Count to handle the generation of number of decryption S-box keys
	int cnt_s_enc;			//Count to handle rounds during encryption process
	int cnt_s_dec;			//Count to handle rounds during decryption process
	reg [(w/2):0] div_enc;
	reg [(w/2):0] div_dec;
	reg [w-1:0] a;			//Internal stage result storage register for decryption
	reg [w-1:0] b;			//Internal stage result storage register for decryption

	//Module instantiation for encryption
	lfsr_8bit c1(
	.clock(clock),
	.reset(reset),
	.lfsr_seed(lfsr_seed_enc),
	.lfsr_out(lfsr_out_enc)
	);
	
	//Module instantiation for decryption
	lfsr_8bit c2(
	.clock(clock),
	.reset(reset),
	.lfsr_seed(lfsr_seed_dec),
	.lfsr_out(lfsr_out_dec)
	);
	
	//RC5 encyption process
	always_ff @(posedge clock or negedge reset)
	begin
		if (!reset)	//Initializing the various internal signals if reset is at logic HIGH
		begin
			state_enc <= 3'b000;
			p_tmp <= p_in;
			enc_done <= 1'b0;
			div_enc <= 1<<(w/2);
			cnt_s_enc <= 0;
			cnt_g_enc <= 0;
		end
		else
		begin
			if (enc_start == 1'b1)	//The encryption will happen only if enc_start is at active HIGH
			begin
				case (state_enc)
					3'b000:	begin	//S-box key values generation state
						if (cnt_g_enc <= ((2*r)+1))
						begin
							s_enc[cnt_g_enc] <= lfsr_out_enc;
							cnt_g_enc <= cnt_g_enc + 1;
						end
						else
							state_enc <= 3'b001;
						end
					3'b001:	begin 	//Initial addition state
						p_tmp[w-1:w/2] <= (p_tmp[w-1:w/2] + s_enc[0]) % div_enc;
						p_tmp[(w/2)-1:0] <= (p_tmp[(w/2)-1:0] + s_enc[1]) % div_enc;
						cnt_s_enc <= cnt_s_enc + 2;
						state_enc <= 3'b010;
						end
					3'b010:	begin	//Computation of MSB 8-bits state through XORing and left shifting
						p_tmp[w-1:w/2] <= ((((p_tmp[w-1:w/2] ^ p_tmp[(w/2)-1:0]) << (p_tmp[(w/2)-1:0]%(w/2))) | ((p_tmp[w-1:w/2] ^ p_tmp[(w/2)-1:0]) >> ((w/2)-(p_tmp[(w/2)-1:0]%(w/2))))) + s_enc[cnt_s_enc]) % div_enc;
						cnt_s_enc <= cnt_s_enc + 1;
						state_enc <= 3'b011;
						end
					3'b011:	begin 	//Computation of LSB 8-bits state_enc through XORing and left shifting
						p_tmp[(w/2)-1:0] <= ((((p_tmp[(w/2)-1:0] ^ p_tmp[w-1:w/2]) << (p_tmp[w-1:w/2]%(w/2))) | ((p_tmp[(w/2)-1:0] ^ p_tmp[w-1:w/2]) >> ((w/2) - (p_tmp[w-1:w/2]%(w/2))))) + s_enc[cnt_s_enc]) % div_enc; 
						if (cnt_s_enc < 2*(r+1)-1)
						begin
							cnt_s_enc <= cnt_s_enc + 1;
							state_enc <= 3'b010;
						end
						else
							state_enc <= 3'b100;
						end
					3'b100:	begin 	//Final encrypted value assignment state
						c_out[w-1:0] <= p_tmp[w-1:0];	
						enc_done <= 1'b1;
						end        
					default: c_out <= 'd0;
				endcase
			end
		end
	end
  
    //RC5 decryption process
	always_ff @(posedge clock or negedge reset)
	begin
		if (!reset)	//Initializing the various internal signals if reset is at logic HIGH
		begin
			state_dec <= 3'b000;
			c_tmp <= c_in;
			dec_done <= 1'b0;
			div_dec <= 1<<(w/2);
			cnt_s_dec <= 0;
			cnt_g_dec <= 0;
		end
		else
		begin
			if (dec_start == 1'b1)	//The decryption will happen only if dec_start is at logic HIGH
			begin
				case (state_dec)
					3'b000:	begin	//S-box key value generation state
						if (cnt_g_dec <= ((2*r)+1))
						begin
							s_dec[cnt_g_dec] <= lfsr_out_dec;
							cnt_g_dec <= cnt_g_dec + 1;
						end
						else
						begin
							cnt_s_dec <= (2*r)+1;
							state_dec <= 3'b001;
						end
						end
					3'b001:	begin	//Subtraction computation state
						b <= (c_tmp[(w/2)-1:0] >= s_dec[cnt_s_dec]) ? (c_tmp[(w/2)-1:0] - s_dec[cnt_s_dec]) : (div_dec + c_tmp[(w/2)-1:0] - s_dec[cnt_s_dec]);
						a <= (c_tmp[w-1:w/2] >= s_dec[cnt_s_dec-1]) ? (c_tmp[w-1:w/2] - s_dec[cnt_s_dec-1]) : (div_dec + c_tmp[w-1:w/2] - s_dec[cnt_s_dec-1]);
						state_dec <= 3'b010;
						end			
					3'b010:	begin	//LSB computation state through XORing and Right shifting
						c_tmp[(w/2)-1:0] <= ((((b[(w/2)-1:0]) >> (c_tmp[w-1:w/2]%(w/2))) | ((b[(w/2)-1:0]) << ((w/2) - (c_tmp[w-1:w/2]%(w/2))))) ^ c_tmp[w-1:w/2]) % div_dec;
						state_dec <= 3'b011;
						end
					3'b011:	begin	//MSB computation state through XORing and Right shifting
						c_tmp[w-1:w/2] <= ((((a[(w/2)-1:0]) >> (c_tmp[(w/2)-1:0]%(w/2))) | ((a[(w/2)-1:0]) << ((w/2) - (c_tmp[(w/2)-1:0]%(w/2))))) ^ c_tmp[(w/2)-1:0]) % div_dec; 
						state_dec <= 3'b100;
						end
					3'b100:	begin 	//Multiround handler state
						if (cnt_s_dec > 3)
						begin				
							cnt_s_dec <= cnt_s_dec - 2;
							state_dec <= 3'b001;
						end
						else
						begin
							cnt_s_dec <= cnt_s_dec - 2;
							state_dec <= 3'b101;
						end
						end
					3'b101:	begin	//Final MSB & LSB computation state
						c_tmp[(w/2)-1:0] <= (c_tmp[(w/2)-1:0] >= s_dec[1]) ? (c_tmp[(w/2)-1:0] - s_dec[1]) : (div_dec + c_tmp[(w/2)-1:0] - s_dec[1])% div_dec; 
						c_tmp[w-1:w/2]  = (c_tmp[w-1:w/2] >= s_dec[0]) ? (c_tmp[w-1:w/2] - s_dec[0]) : (div_dec + c_tmp[w-1:w/2] - s_dec[0])% div_dec; 
						state_dec <= 3'b110;
						end
					3'b110:	begin	//Output generation state
						p_out <= c_tmp;
						dec_done <= 1'b1;
						end
					default: p_out <= 'd0;
				endcase
			end
		end
	end
endmodule
