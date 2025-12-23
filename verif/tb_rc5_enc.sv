module tb_rc5_enc();
  
	//Parameter to declare number of tests
	parameter delay = 900;
	reg clk,rst;
	logic [15:0] enc_c;
	logic [15:0] enc_p;
	logic enc_done,enc_start;

	//Module instantiation
	rc5_enc_16bit DUT (.clock(clk),
	                   .reset(rst),
					   .enc_start(enc_start),
					   .p(enc_p),
					   .c(enc_c),
					   .enc_done(enc_done));

	//Stimulus generation (clock generation for TB)
	initial begin
		clk = 0;
		repeat(delay)
		begin
			#5 clk = 1'b1;
			#5 clk = 1'b0;
		end
	end

	initial begin 
	
	    //All zeros tests
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h0000;//Test 1
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//All ones tests
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hFFFF;//Test 2
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Alternate 1s-0s test 101010....
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hAAAA;//Test 3
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Alternate 0s-1s test 010101....
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h5555;//Test 4
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//8-bit MSBs zero test
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h00FF;//Test 5
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//8-bit LSBs zero test
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hFF00;//Test 6
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Random value#1 test
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h1234;//Test 7
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Random value#2 test
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h4321;//Test 8
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Random value#3 test
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h567A;//Test 9
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		
		//Check if new plaintext value is taken only if rst = 0
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hFFFF;//Test 10
		#15 rst <= 1'b1; 
		#20 enc_p <= 16'h0000;
		assert (enc_p == 16'hFFFF);
		#50 rst <= 1'b0;

	end

	initial begin
		$dumpvars;
		$dumpfile("dump.vcd");
	end  

	//Monitor to display the stimulus output of DUT
	always@(negedge clk) begin
		$monitor($time,"reset = %b,enc_start =  %d, enc_p = %h enc_c = %h enc_done = %d",rst,enc_start,enc_p,enc_c,enc_done);
        if (enc_done == 1'b1) begin
		    if ((enc_p == 16'h0000) && (enc_c == 16'h2F9E))
			    $display("Ciphertext is correct");
		    else if ((enc_p == 16'hFFFF) && (enc_c == 16'h0703))
			    $display("Ciphertext is correct");
			else if ((enc_p == 16'hAAAA) && (enc_c == 16'hC079))
			    $display("Ciphertext is correct");
			else if ((enc_p == 16'h5555) && (enc_c == 16'h01C7))
			    $display("Ciphertext is correct");
			else if ((enc_p == 16'h00FF) && (enc_c == 16'h9665))
			    $display("Ciphertext is correct");
		    else if ((enc_p == 16'hFF00) && (enc_c == 16'h0E86))
			    $display("Ciphertext is correct");
            else if ((enc_p == 16'h1234) && (enc_c == 16'h6687))
			    $display("Ciphertext is correct");
			else if ((enc_p == 16'h4321) && (enc_c == 16'hA393))
			    $display("Ciphertext is correct");
		    else if ((enc_p == 16'h567A) && (enc_c == 16'hF2E0))
			    $display("Ciphertext is correct");
		    else
			    $display("Ciphertext is not correct or new plaintext applied");
		end
	end
	//TB run time based on number of tests to be executed
	initial begin
		#(delay*1);
		$finish;
	end
  
endmodule

