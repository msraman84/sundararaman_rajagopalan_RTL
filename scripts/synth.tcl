# read verilog
read_verilog -sv /code/rtl/*.sv

# elaborate design hierarchy
hierarchy -check -top rc5_enc_dec_param

# the high-level stuff
proc; opt; fsm; opt; memory; opt

# mapping to internal cell library
techmap; opt

# generic synthesis
synth -top rc5_enc_dec_param
clean

# write synthetized design
write_verilog -noattr /code/rundir/netlist.v
