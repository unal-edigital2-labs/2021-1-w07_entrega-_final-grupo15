vlog -work work Waveform.vwf.vt
vsim -novopt -c -t 1ps -L cyclone10lp_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.GeneradorBaudios_vlg_vec_tst -voptargs="+acc"
add wave /*
run -all
