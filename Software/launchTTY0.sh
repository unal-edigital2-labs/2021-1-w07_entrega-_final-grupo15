#!/bin/bash

#./load.py
echo 'Load done'
echo '================================'
cd firmware
make all
make clean
echo 'make done'
echo '================================'
cd .. 
litex_term /dev/ttyUSB0 --kernel firmware/firmware.bin
