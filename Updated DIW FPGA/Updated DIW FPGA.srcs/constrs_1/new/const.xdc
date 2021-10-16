create_clock -period 3.180 -name clk -waveform {0.000 1.590} -add [get_ports -regexp -filter { NAME =~  ".*clk.*" && DIRECTION == "IN" }]

