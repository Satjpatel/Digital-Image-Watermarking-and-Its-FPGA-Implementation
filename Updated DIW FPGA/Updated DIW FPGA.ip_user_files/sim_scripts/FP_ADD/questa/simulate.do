onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib FP_ADD_opt

do {wave.do}

view wave
view structure
view signals

do {FP_ADD.udo}

run -all

quit -force
