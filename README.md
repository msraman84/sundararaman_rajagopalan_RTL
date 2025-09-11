# RC5\_encryption\_RTL



This is a repo containing RTL implementation of RC5 encryption algorithm. My role is to develop RTL design and testbench of this block cipher algorithm by following the given specification. 



##Input to LLM



There is a systemverilog RTL `rc5\_enc\_16bit.sv` in the /code/rtl directory of the git main branch. This RTL implements the RC5 encryption algorithm by taking 16-bit plain-text input 'p' to produce the 16-bit ciphertext output 'c'. The detailed functionality of this block cipher algorithm has been given in `/code/docs/specification.md` file. While executing the RTL code with the testbench `/code/verif/tb\_rc5\_enc.sv`, the following logs were observed.



Admin@DESKTOP-9GV21IC MINGW64 /e/Phinity\_labs/Phinity\_labs\_rc5 (main)

$ docker-compose run verif

Compiling...

Executing...

VCD info: dumpfile dump.vcd opened for output.

VCD warning: /code/verif/tb\_rc5\_enc.sv:42: $dumpfile called after $dumpvars started,

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



Based on the functionality of RC5 encryption algorithm, the expected and actual outputs are given below:

| Plaintext (p) | Expected Ciphertext (c) | Actual Ciphertext (c) |

|---------------|--------------------------|------------------------|

| FFFF          | 0703                     | E773                   |

| FF00          | 0E86                     | 0F8E                   |

| 00FF          | 9665                     | 765D                   |



Identify the bug(s) in the RTL code and fix them.





\## Output



The bug fixed RTL `/code/rtl/rc5\_enc\_16bit.sv` is given in rc5\_encrption\_1 git branch.
 



\## Testbench



The testbench used for identification of bugs and their correction is given in `/code/verif/tb\_enc\_rc5.sv` file. The logs of the testbench after fixing the RTL bugs are given below.

Admin@DESKTOP-9GV21IC MINGW64 /e/Phinity\_labs/Phinity\_labs\_rc5 (rc5\_encryption\_1)

$ docker-compose run verif

Compiling...

Executing...

VCD info: dumpfile dump.vcd opened for output.

VCD warning: /code/verif/tb\_rc5\_enc.sv:42: $dumpfile called after $dumpvars started,

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









