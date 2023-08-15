set_time_format -unit ns -decimal_places 3

#create_clock -name clk -period 20.000 -waveform {0 10}
create_clock -name {clk} -period 7.000 -waveform { 0.000 4.500 } [get_ports { clk }]
create_clock -name {clk1} -period 7.000 -waveform { 0.000 4.500 } [get_ports { clk1 }]

set_clock_uncertainty -rise_from [get_clocks {clk1}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk1}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk1}] -rise_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk1}] -fall_to [get_clocks {clk}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk1}]  0.030  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk1}]  0.030  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk1}]  0.030  
