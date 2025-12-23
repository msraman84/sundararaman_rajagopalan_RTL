# RC5 Documentation

## Overview

Cryptography is the science of securing multimedia objects such as text, images, audio, and video by scrambling the original data. It includes two primary processes: encryption and decryption. Although cryptography is often applied to text, it can secure any type of digital data. Encryption transforms plaintext into ciphertext, while decryption reverses this process. The aim of encryption is to ensure data privacy, making it challenging for unauthorized users or intruders to access the original information. Cryptographic methods are broadly classified into symmetric and asymmetric ciphers. Symmetric ciphers use the same key for both encryption and decryption, whereas asymmetric ciphers use different keys for each process. Depending on whether the encryption processes data in large blocks or bit by bit, it can be categorized as a block cipher or a stream cipher, respectively. The RC5 algorithm is a symmetric block cipher known for its simplicity and effectiveness in converting plaintext to ciphertext and vice versa. It offers flexible options for adjusting block size, key size, and the number of encryption rounds. The RC5 algorithm employs operations such as modulo addition, left rotation, modulo subtraction, right rotation, and XOR in its encryption and decryption processes.

## Interface details

### RC5 encryption algorithm

### Inputs:
•	**clock (1-bit)** : A single-bit input clock that drives the Finite State Machine executing the encryption algorithm. The clock typically has a 50:50 duty cycle.\
•	**reset (1-bit)**: A control signal that resets the internal states of the encryption system. Synchronous reset has been used in this encryption module\
•	**enc_start (1-bit)**: This is a 1-bit control signal which initiates the encryption process when it holds a logic HIGH\
•	**p (2w-bits)[15:0]** : This is the plain text input for RC5 encryption, generally available in data widths of 16-bit, 32-bit, 64-bit, or 128-bits. Plaintext is processed in two segments of 'w' bits each, aligning with the algorithm’s requirements. For this implementation w = 8

### Output:
•	**c (2w-bits)**: The output from the RC5 encryption algorithm. Like plaintext, ciphertext typically matches the input data width '2w'. When not in reset mode, the ciphertext is generated from the plaintext after a series of specific logical and arithmetic operations, dependent on the number of rounds 'r'.\
•   **enc_done (1-bit)**: This output marks the end of encryption and indicates the presence of stable cipher-text output 


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

#### Detailed Analysis of the FSM Stages

1. Initial Addition (3'b000)

&nbsp;&nbsp;&nbsp;&nbsp; The S-box keys to be used have to be initialised at the beginning of the design as follows\
	assign s[0] = 8'h20;\
	assign s[1] = 8'h10;\
	assign s[2] = 8'hFF;\
	assign s[3] = 8'hFF;\
	The module performs initial modulo additions on the most significant and least significant halves of p_tmp, demonstrating the use of RC5's key mixing in the early stages.

2. Computation States (3'b001 and 3'b010)

&nbsp;&nbsp;&nbsp;&nbsp; These states handle the core of the RC5 encryption's mixing and data transformation, involving complex operations such as XORing, shifting, and modulo operations. State 3'b001 should handle MSB 8-bits computation wherein state 3'b010 should compute the LSB 8-bits. 

3. Final Assignment (3'b011)

&nbsp;&nbsp;&nbsp;&nbsp; The final encrypted data is assigned to the output c, and enc_done is set high, signaling the completion of the encryption process.


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

