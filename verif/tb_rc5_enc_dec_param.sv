module tb_rc5_enc_dec_param;
  
	//Parameter to declare number of tests
	
	parameter w = 16;
	parameter r = 3;
	parameter test_num = 800+(r*300);
	
	reg clk,rst;
	logic [w-1:0] p_in;
	logic [w-1:0] c_out;
	logic [w-1:0] c_in;
	logic [w-1:0] p_out;
	logic enc_done,enc_start,dec_start,dec_done;
	logic [7:0] lfsr_seed_enc;
	logic [7:0] lfsr_seed_dec;

	//Module instantiation
	
	rc5_enc_dec_param    #(.w(w),
                           .r(r)
					  )DUT(.clock(clk),
	                       .reset(rst),
						   .enc_start(enc_start),
						   .dec_start(dec_start),
						   .lfsr_seed_enc(lfsr_seed_enc),
						   .lfsr_seed_dec(lfsr_seed_dec),
						   .p_in(p_in),
						   .c_in(c_in),
						   .p_out(p_out),
						   .c_out(c_out),
						   .enc_done(enc_done),
						   .dec_done(dec_done)
						   );

	//Stimulus generation (clock generation for TB)
	initial begin
		clk = 0;
		repeat(test_num)
		begin
			#5 clk = 1'b1;
			#5 clk = 1'b0;
		end
	end

	initial begin 
	    //Test 1 (Encryption)
		$display("Test 1 - Encryption");
		rst = 1'b0;
		enc_start = 1'b1; dec_start = 1'b0; p_in = 16'h1000;lfsr_seed_enc = 8'hFF;
		#15 rst = 1'b1; 
		#(100+r*40) rst = 1'b0;
					
		//Test 2 (Decryption)
		$display("Test 2 - Decryption");
		dec_start = 1'b1;enc_start = 1'b0; c_in = 16'h5460;lfsr_seed_dec = 8'hFF;
		#15 rst = 1'b1; 
		#(130+r*60) rst = 1'b0;
		
		//Test 3 (Encryption)
		$display("Test 3 - Encryption");
		rst = 1'b0;
		enc_start = 1'b1; dec_start = 1'b0; p_in = 16'hFFFF;lfsr_seed_enc = 8'hFF;
		#15 rst = 1'b1; 
		#(100+r*40) rst = 1'b0;
		
		//Test 4 (Decryption)
		$display("Test 4 - Decryption");
		dec_start = 1'b1;enc_start = 1'b0; c_in = 16'hA788;lfsr_seed_dec = 8'hFF;
		#15 rst = 1'b1; 
		#(130+r*60) rst = 1'b0;
		
		//Test 5 (Encryption)
		$display("Test 5 - Encryption");
		rst = 1'b0;
		enc_start = 1'b1; dec_start = 1'b0; p_in = 16'h0000;lfsr_seed_enc = 8'hFF;
		#15 rst = 1'b1; 
		#(100+r*40) rst = 1'b0;
		
		//Test 6 (Decryption)
		$display("Test 6 - Decryption");
		dec_start = 1'b1;enc_start = 1'b0; c_in = 16'hAD6D;lfsr_seed_dec = 8'hFF;
		#15 rst = 1'b1; 
		#(130+r*60) rst = 1'b0;
	end

	//Monitor to display the stimulus output of DUT
	always@(posedge clk)
		$monitor($time,"rst = %b enc_start =  %d, dec_start = %d, p_in = %h, c_out = %h, enc_done = %d, c_in = %h, p_out = %h, dec_done = %d",rst,enc_start,dec_start,p_in,c_out,enc_done,c_in,p_out,dec_done);

	//TB run time based on number of tests to be executed
	initial begin
		$dumpfile("dump.vcd");
	    $dumpvars(0,tb_rc5_enc_dec_param);
		#(test_num*1);
		$finish;
	end
	
endmodule

