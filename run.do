vlib work
vlog -f src_files.list +cover
vsim -voptargs=+acc work.fifo_top -cover -classdebug -uvmcontrol=all
add wave /fifo_top/fifo_if/*
coverage save FIFO.ucdb -onexit
run -all