onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib FP_SUB_opt

do {wave.do}

view wave
view structure
view signals

do {FP_SUB.udo}

run -all

quit -force
