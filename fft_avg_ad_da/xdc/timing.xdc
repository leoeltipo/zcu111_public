set clk_axi  [get_clocks -of_objects [get_nets -of_objects [get_pins d_1_i/axis_ssrfft_16x16_0/s_axi_aclk]]]
set clk_adc2_x2 [get_clocks -of_objects [get_nets -of_objects [get_pins d_1_i/axis_ssrfft_16x16_0/aclk]]]
set clk_dac1 [get_clocks -of_objects [get_nets -of_objects [get_pins d_1_i/axis_constant_iq_0/m_axis_aclk]]]
    
set_clock_group -name clk_axi_to_adc2_x2 -asynchronous \
    -group [get_clocks $clk_axi] \
    -group [get_clocks $clk_adc2_x2]    
    
set_clock_group -name clk_axi_to_dac1 -asynchronous \
    -group [get_clocks $clk_axi] \
    -group [get_clocks $clk_dac1]
          