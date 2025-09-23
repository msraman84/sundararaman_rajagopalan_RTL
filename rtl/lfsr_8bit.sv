module lfsr_8bit(
	input wire clock,		//Clock input
	input wire reset,		//Reset input
	input wire [7:0] lfsr_seed, 	//8-bit LFSR seed
	output reg [7:0] lfsr_out); 	//8-bit LFSR output
	
	wire q1,q2,q3;
	
	//Primitive polynomial considered for 8-bit LFSR is x^8+x^6+x^5+x+1 
	
	//Internal XORing based on primitive polynomial
	assign q1 = lfsr_out[6] ^ lfsr_out[0];
	assign q2 = lfsr_out[5] ^ lfsr_out[0];
	assign q3 = lfsr_out[1] ^ lfsr_out[0];

	always_ff @(posedge clock or negedge reset)
	begin
		if (!reset)	//If reset is HIGH, 8-bit seed will be initialized at LFSR output
			lfsr_out <= lfsr_seed;
		else
			lfsr_out <= {lfsr_out[0],lfsr_out[7],q1,q2,lfsr_out[4],lfsr_out[3],lfsr_out[2],q3};//Shift register based on the primitive polynomial
	end
endmodule
