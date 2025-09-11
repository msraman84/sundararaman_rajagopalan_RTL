module tb_rc5_enc();
  
	//Parameter to declare number of tests
	parameter delay = 300;
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

	initial begin //Initial Reset 
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hFFFF;//Test 1
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'hFF00;//Test 2
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
		rst = 1'b0;enc_start <= 1'b1; enc_p <= 16'h00FF;//Test 3
		#15 rst <= 1'b1; 
		#70 rst <= 1'b0;
	end

	initial begin
		$dumpvars;
		$dumpfile("dump.vcd");
	end  

	//Monitor to display the stimulus output of DUT
	always@(negedge clk) begin
		$monitor($time,"enc_start =  %d, enc_p = %h enc_c = %h enc_done = %d",enc_start,enc_p,enc_c,enc_done);
        if (enc_done == 1'b1) begin
		    if ((enc_p == 16'hFFFF) && (enc_c == 16'h0703))
			    $display("Ciphertext is correct");
		    else if ((enc_p == 16'hFF00) && (enc_c == 16'h0E86))
			    $display("Ciphertext is correct");
		    else if ((enc_p == 16'h00FF) && (enc_c == 16'h9665))
			    $display("Ciphertext is correct");
		    else
			    $display("Ciphertext is not correct");
		end
	end
	//TB run time based on number of tests to be executed
	initial begin
		#(delay*1);
		$finish;
	end
  
endmodule

