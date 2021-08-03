PACKAGES=libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata bios
PACKAGE_DIRS=/home/sergio/install_litex/litex/litex/soc/software/libcompiler_rt /home/sergio/install_litex/litex/litex/soc/software/libbase /home/sergio/install_litex/litex/litex/soc/software/libfatfs /home/sergio/install_litex/litex/litex/soc/software/liblitespi /home/sergio/install_litex/litex/litex/soc/software/liblitedram /home/sergio/install_litex/litex/litex/soc/software/libliteeth /home/sergio/install_litex/litex/litex/soc/software/liblitesdcard /home/sergio/install_litex/litex/litex/soc/software/liblitesata /home/sergio/install_litex/litex/litex/soc/software/bios
LIBS=libcompiler_rt libbase-nofloat libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata
TRIPLE=riscv64-unknown-elf
CPU=picorv32
CPUFLAGS=-mno-save-restore -march=rv32im     -mabi=ilp32 -D__picorv32__ 
CPUENDIANNESS=little
CLANG=0
CPU_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/cores/cpu/picorv32
SOC_DIRECTORY=/home/sergio/install_litex/litex/litex/soc
COMPILER_RT_DIRECTORY=/home/sergio/install_litex/pythondata-software-compiler_rt/pythondata_software_compiler_rt/data
export BUILDINC_DIRECTORY
BUILDINC_DIRECTORY=/home/sergio/Documents/U/Github_Digital/Final_Project_Digital/Grupo-5-proyecto/build/nexys4ddr/software/include
LIBCOMPILER_RT_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/libcompiler_rt
LIBBASE_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/libbase
LIBFATFS_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/libfatfs
LIBLITESPI_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/liblitespi
LIBLITEDRAM_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/liblitedram
LIBLITEETH_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/libliteeth
LIBLITESDCARD_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/liblitesdcard
LIBLITESATA_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/liblitesata
BIOS_DIRECTORY=/home/sergio/install_litex/litex/litex/soc/software/bios