transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/ECE2072/Lab2 {C:/intelFPGA_lite/ECE2072/Lab2/comparison_module.v}
vlog -vlog01compat -work work +incdir+C:/intelFPGA_lite/ECE2072/Lab2 {C:/intelFPGA_lite/ECE2072/Lab2/example_testbench.v}

