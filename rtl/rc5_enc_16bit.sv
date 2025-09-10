module rc5_enc_16bit(input clock,reset,enc_start, input [15:0]p, output reg [15:0]c, output reg enc_done);
	//enc_start - HIGH to start the encryption; p - 16-bit plaintext input ; 
	//c - 16-bit cipher text output ; enc_done - Encryption output availability indicator
	logic [7:0]s[0:3];
	reg [15:0] p_tmp;//Internal signal to handle encryption operation 
	reg [2:0] state;//State representation to manage operations of encryption algorithm FSM
	assign s[0] = 8'h20;//S-box variables assignment
	assign s[1] = 8'h10;
	assign s[2] = 8'h0F;
	assign s[3] = 8'hFF;
	always_ff @(posedge clock)//Encryption is carried out during positive clock edges of clock input
	begin
		if (!reset)//State will be at "000" during reset at LOW and p_tmp will carry the input plain text
		begin
			state <= 3'b000;
			p_tmp <= p;
			enc_done <= 1'b0;
		end
		else
		begin
			if (enc_start == 1'b1)//If enc_start is HIGH, the encryption process begins
			begin
				case (state)
				3'b000:	begin //Initial addition stage
						p_tmp[15:8] <= (p_tmp[15:8] + s[0]) % 9'h100;
						p_tmp[7:0] <= (p_tmp[7:0] + s[1]) % 9'h100;
						state <= 3'b001;
						end
				3'b001:	begin // Computation of MSB 8-bits
						p_tmp[15:8] <= ((((p_tmp[15:8] ^ p_tmp[7:0]) << (p_tmp[7:0]%8)) | ((p_tmp[15:8] ^ p_tmp[7:0]) >> (8 - (p_tmp[7:0]%8)))) + s[2]) % 9'h100;
						state <= 3'b010;
						end
				3'b010:	begin //Computation of LSB 8-bits
						p_tmp[7:0] <= ((((p_tmp[7:0] ^ p_tmp[15:8]) << (p_tmp[15:8]%8)) | ((p_tmp[7:0] ^ p_tmp[15:8]) >> (8 - (p_tmp[15:8]%8)))) + s[3]) % 9'h100;
						state <= 3'b011;
						end
				3'b011:	begin //Final encrypted 16-bit value
						c[15:0] <= p_tmp [15:0];
						enc_done <= 1'b1;
						end        
				default:c <= 16'd0;
				endcase
			end
		end
	end
endmodule
 
