#include "vga.h"
#include <generated/csr.h>

void vga_draw(unsigned int x, unsigned int y)
{
	VGA_Mapa_MapaData_write(2); 
	VGA_Mapa_MapaAddr_write((x)+(y)*8);
	VGA_Mapa_MapaWrite_write(1);
	VGA_Mapa_MapaWrite_write(0);
}

void vga_rst(void)
{
	int x,y;
	//pinta toda la pantalla de negro
	for(y=0; y<8; y++) {
			for(x=0; x<8; x++) {
				VGA_Mapa_MapaWrite_write(0);
				VGA_Mapa_MapaData_write(0); 
				VGA_Mapa_MapaAddr_write((x)+(y)*8);
				VGA_Mapa_MapaWrite_write(1);
				VGA_Mapa_MapaWrite_write(0);	
			}
		}
}