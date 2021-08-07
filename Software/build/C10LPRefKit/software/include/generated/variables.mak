PACKAGES=libcompiler_rt libbase libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata bios
PACKAGE_DIRS=/home/oyuky/install_litex/litex/litex/soc/software/libcompiler_rt /home/oyuky/install_litex/litex/litex/soc/software/libbase /home/oyuky/install_litex/litex/litex/soc/software/libfatfs /home/oyuky/install_litex/litex/litex/soc/software/liblitespi /home/oyuky/install_litex/litex/litex/soc/software/liblitedram /home/oyuky/install_litex/litex/litex/soc/software/libliteeth /home/oyuky/install_litex/litex/litex/soc/software/liblitesdcard /home/oyuky/install_litex/litex/litex/soc/software/liblitesata /home/oyuky/install_litex/litex/litex/soc/software/bios
LIBS=libcompiler_rt libbase-nofloat libfatfs liblitespi liblitedram libliteeth liblitesdcard liblitesata
TRIPLE=riscv64-unknown-elf
CPU=picorv32
CPUFLAGS=-mno-save-restore -march=rv32im     -mabi=ilp32 -D__picorv32__ 
CPUENDIANNESS=little
CLANG=0
CPU_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/cores/cpu/picorv32
SOC_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc
COMPILER_RT_DIRECTORY=/home/oyuky/install_litex/pythondata-software-compiler_rt/pythondata_software_compiler_rt/data
export BUILDINC_DIRECTORY
BUILDINC_DIRECTORY=/home/oyuky/Grupo-5-proyecto/Software/build/C10LPRefKit/software/include
LIBCOMPILER_RT_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/libcompiler_rt
LIBBASE_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/libbase
LIBFATFS_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/libfatfs
LIBLITESPI_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/liblitespi
LIBLITEDRAM_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/liblitedram
LIBLITEETH_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/libliteeth
LIBLITESDCARD_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/liblitesdcard
LIBLITESATA_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/liblitesata
BIOS_DIRECTORY=/home/oyuky/install_litex/litex/litex/soc/software/bios