# RC5 Documentation

## Overview

Cryptography is the science of securing multimedia objects such as text, images, audio, and video by scrambling the original data. It includes two primary processes: encryption and decryption. Although cryptography is often applied to text, it can secure any type of digital data. Encryption transforms plaintext into ciphertext, while decryption reverses this process. The aim of encryption is to ensure data privacy, making it challenging for unauthorized users or intruders to access the original information. Cryptographic methods are broadly classified into symmetric and asymmetric ciphers. Symmetric ciphers use the same key for both encryption and decryption, whereas asymmetric ciphers use different keys for each process. Depending on whether the encryption processes data in large blocks or bit by bit, it can be categorized as a block cipher or a stream cipher, respectively. The RC5 algorithm is a symmetric block cipher known for its simplicity and effectiveness in converting plaintext to ciphertext and vice versa. It offers flexible options for adjusting block size, key size, and the number of encryption rounds. The RC5 algorithm employs operations such as modulo addition, left rotation, modulo subtraction, right rotation, and XOR in its encryption and decryption processes.

## Functionality

### RC5 Encryption algorithm

In order to understand the RC5 block cipher encryption, the following parameters are needed:
1. Plaintext (P)
2. Plaintext as w-bit registers (A & B)
2. Data width (2w)
3. S-box key array (S)
4. Rounds of operation (r)
5. Ciphertext (C)

The RC5 encryption algorithm works as follows:

A = A + S[0];\
B = B + S[1];\
for i = 1 to r do\
&nbsp;&nbsp;&nbsp;&nbsp;A = ((A XOR B) <<< B) + S[2&times;i];\
&nbsp;&nbsp;&nbsp;&nbsp;B = ((B XOR A) <<< A) + S[(2&times;i)+1];\
C = {A,B}

Here, <<< : Left rotation; + : Modulo 2<sup>w</sup> addition; A : MSB w-bits of plaintext P;\
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B : LSB w-bits of plaintext P; S[0],S[1],S[2],....... : S-box keys ; {} : Concatenation

At the beginning of encryption, the MSB w-bits of plaintext is assumed as A and LSB w-bits of plaintext as B. Every step of this algorithm has to be carried out sequentially as the subsequent steps utilize the result of previous computations. Even though the encryption can be carried out on any data-width, the recommended plaintext widths are 16,32 or 64. The number of S-box keys for the encryption is 2*(r+1), where 'r' represents the number of rounds. As the number of rounds increases, the algorithm requires more number of S-box keys. In general, S-box keys are assumed by the user during the encryption process which need to be shared for executing the decryption.

### FSM-Controlled Process 

When the reset is LOW, state should be initialized to 3'b000 and enc_done has to be maintained at zero. The FSM orchestrates the encryption process, guiding the data through initial setup, S-box key generation, data transformation, and final output stages.

## Working example 

### RC5 Encryption

Let us consider the following parameters:

P = 16'hFFFF ; w = 8 ; r = 1 ; S[0] = 8'h20;S[1] = 8'h10;S[2] = 8'hFF;S[3] = 8'hFF;

Solution:

A = 8'hFF; B = 8'hFF

A = (8'hFF + 8'h20) mod 256 = 1F\
B = (8'hFF + 8'h10) mod 256 = 0F

(Loop computation)\
&nbsp;&nbsp;&nbsp;&nbsp;A = (((8'h1F XOR 8'h0F) <<< 8'h0F) + 8'hFF) mod 256 = (8'h08 + 8'hFF) mod 256 = 8'h07\
&nbsp;&nbsp;&nbsp;&nbsp;B = (((8'h0F XOR 8'h07) <<< 8'h07) + 8'hFF) mod 256 = (8'h04 + 8'hFF) mod 256 = 8'h03

The ciphertext output is C = 16'h0703

### Partial RTL code

```verilog
module rc5_enc_16bit(input clock,//Positive edge-triggered clock
                     input reset,//Asynchronous active low reset
					 input enc_start, //When HIGH, encryption begins
					 input [15:0]p, //Plaintext input
					 output reg [15:0]c, //Ciphertext output
					 output reg enc_done); //When HIGH, indicates the stable ciphertext output
	//Insert internal signal declarations
	
    always_ff @(posedge clock or negedge reset)
	begin
		if (!reset)
		begin
			state <= 3'b000;
			p_tmp <= p;
			enc_done <= 1'b0;
            c <= 'd0;
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
                        //Insert code section here
						end
				3'b010:	begin //Computation of LSB 8-bits
                        //Insert code section here
						end
				3'b011:	begin //Final encrypted 16-bit value
                        //Insert code section here
						end        
				default:c <= 16'd0;
				endcase
			end
		end
	end
	
	//Insert assertion to check if final encrypted value appears during state 3'b011
	
	//Insert assertion to check if the encrypted value appears at fourth clock cycle after enc_start is HIGH
	
	//Insert assertion to check if the enc_done is HIGH at fourth clock cycle after enc_start is HIGH
	
	//Insert assertion to check if c value is zero when the reset is at active LOW
	
endmodule
```
