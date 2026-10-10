read_liberty timing_lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog synthesized_sky130_mac.v

link_design mac_synth_top

create_clock -name clk -period 16.2 [get_ports clk]

set_input_delay 0 -clock clk [get_ports {a b c enable}]
set_output_delay 0 -clock clk [get_ports {result done}]

set_false_path -from [get_ports reset]


report_checks -path_delay max -fields {slew cap input_pin} -digits 3

report_wns
report_tns
