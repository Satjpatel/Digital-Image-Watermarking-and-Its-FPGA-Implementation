onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib FP_MUL_opt

do {wave.do}

view wave
view structure
view signals

do {FP_MUL.udo}

run -all

quit -force
