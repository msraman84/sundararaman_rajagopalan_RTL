## Input to LLM

There is a systemverilog RTL `rc5_enc_16bit.sv` in the `/code/rtl` directory of the git main branch. This RTL implements the RC5 encryption algorithm by taking 16-bit plain-text input 'p' to produce the 16-bit ciphertext output 'c'. The detailed functionality of this block cipher algorithm has been given in `/code/docs/specification.md` file. While executing the RTL code with the testbench `/code/verif/tb_rc5_enc.sv`, the following logs were observed.

```
$ docker-compose run verif
Compiling...
Executing...
VCD info: dumpfile dump.vcd opened for output.
VCD warning: /code/verif/tb_rc5_enc.sv:42: $dumpfile called after $dumpvars started,
                                           using existing file (dump.vcd).
                  10enc_start =  1, enc_p = ffff enc_c = xxxx enc_done = 0
                  20enc_start =  1, enc_p = ffff enc_c = xxxx enc_done = 0
                  30enc_start =  1, enc_p = ffff enc_c = xxxx enc_done = 0
                  40enc_start =  1, enc_p = ffff enc_c = xxxx enc_done = 0
                  50enc_start =  1, enc_p = ffff enc_c = xxxx enc_done = 0
                  55enc_start =  1, enc_p = ffff enc_c = xxe2 enc_done = 1
Ciphertext is not correct
                  60enc_start =  1, enc_p = ffff enc_c = xxe2 enc_done = 1
Ciphertext is not correct
                  70enc_start =  1, enc_p = ffff enc_c = xxe2 enc_done = 1
Ciphertext is not correct
                  80enc_start =  1, enc_p = ffff enc_c = xxe2 enc_done = 1
                  85enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                  90enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                 100enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                 110enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                 120enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                 130enc_start =  1, enc_p = ff00 enc_c = xxe2 enc_done = 0
                 135enc_start =  1, enc_p = ff00 enc_c = xx8e enc_done = 1
Ciphertext is not correct
                 140enc_start =  1, enc_p = ff00 enc_c = xx8e enc_done = 1
Ciphertext is not correct
                 150enc_start =  1, enc_p = ff00 enc_c = xx8e enc_done = 1
Ciphertext is not correct
                 160enc_start =  1, enc_p = ff00 enc_c = xx8e enc_done = 1
Ciphertext is not correct
                 170enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 1
                 175enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 180enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 190enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 200enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 210enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 220enc_start =  1, enc_p = 00ff enc_c = xx8e enc_done = 0
                 225enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 1
Ciphertext is not correct
                 230enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 1
Ciphertext is not correct
                 240enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 1
Ciphertext is not correct
                 250enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 1
Ciphertext is not correct
                 260enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 1
                 265enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 0
                 270enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 0
                 280enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 0
                 290enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 0
/code/verif/tb_rc5_enc.sv:62: $finish called at 300 (1s)
                 300enc_start =  1, enc_p = 00ff enc_c = xxfe enc_done = 0
```
Based on the functionality of RC5 encryption algorithm, the expected and actual outputs are given below:

| Plaintext (p) | Expected Ciphertext (c) | Actual Ciphertext (c) |

|---------------|--------------------------|------------------------|

| FFFF          | 0703                     | xxE2                   |

| FF00          | 0E86                     | xx8E                   |

| 00FF          | 9665                     | xxFE                   |


Identify the bug(s) in the RTL code and fix them.
