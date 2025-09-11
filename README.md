# sundararaman_rajagopalan_RTL


## Description of select project and role

Cryptography is the science of securing multimedia objects such as text, images, audio, and video by scrambling the original data. It includes two primary processes: encryption and decryption. Although cryptography is often applied to text, it can secure any type of digital data. Encryption transforms plaintext into ciphertext, while decryption reverses this process. The aim of encryption is to ensure data privacy, making it challenging for unauthorized users or intruders to access the original information. Cryptographic methods are broadly classified into symmetric and asymmetric ciphers. Symmetric ciphers use the same key for both encryption and decryption, whereas asymmetric ciphers use different keys for each process. Depending on whether the encryption processes data in large blocks or bit by bit, it can be categorized as a block cipher or a stream cipher, respectively. The RC5 algorithm is a symmetric block cipher known for its simplicity and effectiveness in converting plaintext to ciphertext and vice versa. It offers flexible options for adjusting block size, key size, and the number of encryption rounds. The RC5 algorithm employs operations such as modulo addition, left rotation, modulo subtraction, right rotation, and XOR in its encryption and decryption processes. This is a repo containing RTL implementation of RC5 encryption algorithm. My role is to develop RTL design and testbench of this block cipher algorithm by following the given specification. If required, the identification of bugs and rectify them is also one of the important tasks.

## Input to LLM

There is a systemverilog RTL `rc5_enc_16bit.sv` in the `/code/rtl` directory of the git main branch. This RTL implements the RC5 encryption algorithm by taking 16-bit plain-text input 'p' to produce the 16-bit ciphertext output 'c'. The detailed functionality of this block cipher algorithm has been given in `/code/docs/specification.md` file. While executing the RTL code with the testbench `/code/verif/tb_rc5_enc.sv`, the following logs were observed.


```
Admin@DESKTOP-9GV21IC MINGW64 /e/Phinity\_labs/Phinity\_labs\_rc5 (main)

$ docker-compose run verif

Compiling...

Executing...

VCD info: dumpfile dump.vcd opened for output.

VCD warning: /code/verif/tb_rc5_enc.sv:42: $dumpfile called after $dumpvars started,

&nbsp;                                          using existing file (dump.vcd).

&nbsp;                 10enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 20enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 30enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 40enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 50enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 55enc\_start =  1, enc\_p = ffff enc\_c = e773 enc\_done = 1

Ciphertext is not correct

&nbsp;                 60enc\_start =  1, enc\_p = ffff enc\_c = e773 enc\_done = 1

Ciphertext is not correct

&nbsp;                 70enc\_start =  1, enc\_p = ffff enc\_c = e773 enc\_done = 1

Ciphertext is not correct

&nbsp;                 80enc\_start =  1, enc\_p = ffff enc\_c = e773 enc\_done = 1

&nbsp;                 85enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                 90enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                100enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                110enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                120enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                130enc\_start =  1, enc\_p = ff00 enc\_c = e773 enc\_done = 0

&nbsp;                135enc\_start =  1, enc\_p = ff00 enc\_c = 0f8e enc\_done = 1

Ciphertext is not correct

&nbsp;                140enc\_start =  1, enc\_p = ff00 enc\_c = 0f8e enc\_done = 1

Ciphertext is not correct

&nbsp;                150enc\_start =  1, enc\_p = ff00 enc\_c = 0f8e enc\_done = 1

Ciphertext is not correct

&nbsp;                160enc\_start =  1, enc\_p = ff00 enc\_c = 0f8e enc\_done = 1

Ciphertext is not correct

&nbsp;                170enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 1

&nbsp;                175enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                180enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                190enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                200enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                210enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                220enc\_start =  1, enc\_p = 00ff enc\_c = 0f8e enc\_done = 0

&nbsp;                225enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 1

Ciphertext is not correct

&nbsp;                230enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 1

Ciphertext is not correct

&nbsp;                240enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 1

Ciphertext is not correct

&nbsp;                250enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 1

Ciphertext is not correct

&nbsp;                260enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 1

&nbsp;                265enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 0

&nbsp;                270enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 0

&nbsp;                280enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 0

&nbsp;                290enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 0

/code/verif/tb\_rc5\_enc.sv:62: $finish called at 300 (1s)

&nbsp;                300enc\_start =  1, enc\_p = 00ff enc\_c = 765d enc\_done = 0
```


Based on the functionality of RC5 encryption algorithm, the expected and actual outputs are given below:

| Plaintext (p) | Expected Ciphertext (c) | Actual Ciphertext (c) |

|---------------|--------------------------|------------------------|

| FFFF          | 0703                     | E773                   |

| FF00          | 0E86                     | 0F8E                   |

| 00FF          | 9665                     | 765D                   |


Identify the bug(s) in the RTL code and fix them.

## Output

The bug fixed RTL `/code/rtl/rc5_enc_16bit.sv` is given in git branch `rc5_encryption_1`.
 
## Testbench

The testbench used for identification of bugs and their correction is given in `/code/verif/tb_enc_rc5.sv` file. The logs of the testbench after fixing the RTL bugs are given below.

```
Admin@DESKTOP-9GV21IC MINGW64 /e/Phinity\_labs/Phinity\_labs\_rc5 (rc5_encryption_1)

$ docker-compose run verif

Compiling...

Executing...

VCD info: dumpfile dump.vcd opened for output.

VCD warning: /code/verif/tb_rc5_enc.sv:42: $dumpfile called after $dumpvars started,

&nbsp;                                          using existing file (dump.vcd).

&nbsp;                 10enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 20enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 30enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 40enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 50enc\_start =  1, enc\_p = ffff enc\_c = xxxx enc\_done = 0

&nbsp;                 55enc\_start =  1, enc\_p = ffff enc\_c = 0703 enc\_done = 1

Ciphertext is correct

&nbsp;                 60enc\_start =  1, enc\_p = ffff enc\_c = 0703 enc\_done = 1

Ciphertext is correct

&nbsp;                 70enc\_start =  1, enc\_p = ffff enc\_c = 0703 enc\_done = 1

Ciphertext is correct

&nbsp;                 80enc\_start =  1, enc\_p = ffff enc\_c = 0703 enc\_done = 1

&nbsp;                 85enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                 90enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                100enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                110enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                120enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                130enc\_start =  1, enc\_p = ff00 enc\_c = 0703 enc\_done = 0

&nbsp;                135enc\_start =  1, enc\_p = ff00 enc\_c = 0e86 enc\_done = 1

Ciphertext is correct

&nbsp;                140enc\_start =  1, enc\_p = ff00 enc\_c = 0e86 enc\_done = 1

Ciphertext is correct

&nbsp;                150enc\_start =  1, enc\_p = ff00 enc\_c = 0e86 enc\_done = 1

Ciphertext is correct

&nbsp;                160enc\_start =  1, enc\_p = ff00 enc\_c = 0e86 enc\_done = 1

Ciphertext is correct

&nbsp;                170enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 1

&nbsp;                175enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                180enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                190enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                200enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                210enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                220enc\_start =  1, enc\_p = 00ff enc\_c = 0e86 enc\_done = 0

&nbsp;                225enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 1

Ciphertext is correct

&nbsp;                230enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 1

Ciphertext is correct

&nbsp;                240enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 1

Ciphertext is correct

&nbsp;                250enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 1

Ciphertext is correct

&nbsp;                260enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 1

&nbsp;                265enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 0

&nbsp;                270enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 0

&nbsp;                280enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 0

&nbsp;                290enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 0

/code/verif/tb\_rc5\_enc.sv:62: $finish called at 300 (1s)

&nbsp;                300enc\_start =  1, enc\_p = 00ff enc\_c = 9665 enc\_done = 0
```

## Reasoning

Two bugs were identified while ananlyzing the given buggy RTL with the specification. The bugs were present in the following lines of the RTL code.

Line number 25:

`p_tmp[15:8] <= (p_tmp[15:8] - s[0]) % 9'h100;`

Line number 30:

`p_tmp[15:8] <= ((((p_tmp[15:8] & p_tmp[7:0]) << (p_tmp[7:0]%8)) | ((p_tmp[15:8] ^ p_tmp[7:0]) >> (8 - (p_tmp[7:0]%8)))) + s[2]) % 9'h100;`

In the former case, instead of addition operation, subtraction was carried out. In the later, bitwise AND operation was done instead of XOR logic. Because of these two logic deviations, the testbench logs showed as `ciphertext not correct`. After resolving these logic mistakes, the modified RTL matches with the specification.

## Notes

1. The windows 11 operating system was used in this work. The systemverilog RTL code was compiled with Icarus tool. The docker-compose.yml file was used to execute RTL compilation and TB execution.
2. The command `docker-compose run synth` was used to verify the synthesis output of RTL code
3. The command `docker-compose run verif` was used to check the testbench output
4. synth.tcl file is needed for running the synthesis
