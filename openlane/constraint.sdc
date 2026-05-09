create_clock [get_ports clk] -period 10

set_input_delay 1 -clock clk [all_inputs]

set_output_delay 1 -clock clk [all_outputs]

set_max_fanout 4 [current_design]