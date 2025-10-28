transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/Anuj/ai/Verilog/op_amp/code {D:/Anuj/ai/Verilog/op_amp/code/op_amp.v}
vlog -vlog01compat -work work +incdir+D:/Anuj/ai/Verilog/op_amp/code {D:/Anuj/ai/Verilog/op_amp/code/diff_amplifier.v}
vlog -vlog01compat -work work +incdir+D:/Anuj/ai/Verilog/op_amp/code {D:/Anuj/ai/Verilog/op_amp/code/output_stage.v}
vlog -vlog01compat -work work +incdir+D:/Anuj/ai/Verilog/op_amp/code {D:/Anuj/ai/Verilog/op_amp/code/gain_stage.v}

