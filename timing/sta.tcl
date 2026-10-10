read_liberty timing_lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog synthesized_sky130_riscv_cpu.v

link_design riscv_synth_top

create_clock -name clk -period 10 [get_ports clk]

set_input_delay 0 -clock clk [get_ports reset]

set_output_delay 0 -clock clk [get_ports {pc_out instruction_out mac_result_out mac_busy_out mac_done_out}]

report_checks -path_delay max -fields {slew cap input_pin} -digits 3

report_wns

report_tns
