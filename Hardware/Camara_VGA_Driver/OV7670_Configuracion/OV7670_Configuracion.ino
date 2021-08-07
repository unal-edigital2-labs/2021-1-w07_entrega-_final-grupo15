#include <Wire.h>

#define OV7670_I2C_ADDRESS  0x21 /*Direccion OV7670*/

#define VGA_WIDTH   640
#define VGA_HEIGHT  480
#define QVGA_WIDTH  320
#define QVGA_HEIGHT 240
#define CIF_WIDTH   352
#define CIF_HEIGHT  288
#define QCIF_WIDTH  176
#define QCIF_HEIGHT 144

/* Registros */
#define REG_GAIN        0x00  /* Gain lower 8 bits (rest in vref) */
#define REG_BLUE        0x01  /* blue gain */
#define REG_RED         0x02  /* red gain */
#define REG_VREF        0x03  /* Pieces of GAIN, VSTART, VSTOP */
#define REG_COM1        0x04  /* Control 1 */
#define COM1_CCIR656    0x40  /* CCIR656 enable */
#define REG_BAVE        0x05  /* U/B Average level */
#define REG_GbAVE       0x06  /* Y/Gb Average level */
#define REG_AECHH       0x07  /* AEC MS 5 bits */
#define REG_RAVE        0x08  /* V/R Average level */
#define REG_COM2        0x09  /* Control 2 */
#define COM2_SSLEEP     0x10  /* Soft sleep mode */
#define REG_PID         0x0a  /* Product ID MSB */
#define REG_VER         0x0b  /* Product ID LSB */
#define REG_COM3        0x0c  /* Control 3 */
#define COM3_SWAP       0x40  /* Byte swap */
#define COM3_SCALEEN    0x08  /* Enable scaling */
#define COM3_DCWEN      0x04  /* Enable downsamp/crop/window */
#define REG_COM4        0x0d  /* Control 4 */
#define REG_COM5        0x0e  /* All "reserved" */
#define REG_COM6        0x0f  /* Control 6 */
#define REG_AECH        0x10  /* More bits of AEC value */
#define REG_CLKRC       0x11  /* Clocl control */
#define CLK_EXT         0x40  /* Use external clock directly */
#define CLK_SCALE       0x3f  /* Mask for internal clock scale */
#define REG_COM7        0x12  /* Control 7 */
#define COM7_RESET      0x80  /* Register reset */
#define COM7_FMT_MASK   0x38
#define COM7_FMT_VGA    0x00
#define COM7_FMT_CIF    0x20  /* CIF format */
#define COM7_FMT_QVGA   0x10  /* QVGA format */
#define COM7_FMT_QCIF   0x08  /* QCIF format */
#define COM7_RGB        0x04  /* bits 0 and 2 - RGB format */
#define COM7_YUV        0x00  /* YUV */
#define COM7_BAYER      0x01  /* Bayer format */
#define COM7_PBAYER     0x05  /* "Processed bayer" */
#define REG_COM8        0x13  /* Control 8 */
#define COM8_FASTAEC    0x80  /* Enable fast AGC/AEC */
#define COM8_AECSTEP    0x40  /* Unlimited AEC step size */
#define COM8_BFILT      0x20  /* Band filter enable */
#define COM8_AGC        0x04  /* Auto gain enable */
#define COM8_AWB        0x02  /* White balance enable */
#define COM8_AEC        0x01  /* Auto exposure enable */
#define REG_COM9        0x14  /* Control 9  - gain ceiling */
#define REG_COM10       0x15  /* Control 10 */
#define COM10_HSYNC     0x40  /* HSYNC instead of HREF */
#define COM10_PCLK_HB   0x20  /* Suppress PCLK on horiz blank */
#define COM10_HREF_REV  0x08  /* Reverse HREF */
#define COM10_VS_LEAD   0x04  /* VSYNC on clock leading edge */
#define COM10_VS_NEG    0x02  /* VSYNC negative */
#define COM10_HS_NEG    0x01  /* HSYNC negative */
#define REG_HSTART      0x17  /* Horiz start high bits */
#define REG_HSTOP       0x18  /* Horiz stop high bits */
#define REG_VSTART      0x19  /* Vert start high bits */
#define REG_VSTOP       0x1a  /* Vert stop high bits */
#define REG_PSHFT       0x1b  /* Pixel delay after HREF */
#define REG_MIDH        0x1c  /* Manuf. ID high */
#define REG_MIDL        0x1d  /* Manuf. ID low */
#define REG_MVFP        0x1e  /* Mirror / vflip */
#define MVFP_MIRROR     0x20  /* Mirror image */
#define MVFP_FLIP       0x10  /* Vertical flip */
#define REG_AEW         0x24  /* AGC upper limit */
#define REG_AEB         0x25  /* AGC lower limit */
#define REG_VPT         0x26  /* AGC/AEC fast mode op region */
#define REG_HSYST       0x30  /* HSYNC rising edge delay */
#define REG_HSYEN       0x31  /* HSYNC falling edge delay */
#define REG_HREF        0x32  /* HREF pieces */
#define REG_TSLB        0x3a  /* lots of stuff */
#define TSLB_YLAST      0x04  /* UYVY or VYUY - see com13 */
#define REG_COM11       0x3b  /* Control 11 */
#define COM11_NIGHT     0x80  /* NIght mode enable */
#define COM11_NMFR      0x60  /* Two bit NM frame rate */
#define COM11_HZAUTO    0x10  /* Auto detect 50/60 Hz */
#define COM11_50HZ      0x08  /* Manual 50Hz select */
#define COM11_EXP       0x02
#define REG_COM12       0x3c  /* Control 12 */
#define COM12_HREF      0x80  /* HREF always */
#define REG_COM13       0x3d  /* Control 13 */
#define COM13_GAMMA     0x80  /* Gamma enable */
#define COM13_UVSAT     0x40  /* UV saturation auto adjustment */
#define COM13_UVSWAP    0x01  /* V before U - w/TSLB */
#define REG_COM14       0x3e  /* Control 14 */
#define COM14_DCWEN     0x10  /* DCW/PCLK-scale enable */
#define REG_EDGE        0x3f  /* Edge enhancement factor */
#define REG_COM15       0x40  /* Control 15 */
#define COM15_R10F0     0x00  /* Data range 10 to F0 */
#define COM15_R01FE     0x80  /*            01 to FE */
#define COM15_R00FF     0xc0  /*            00 to FF */
#define COM15_RGB565    0x10  /* RGB565 output */
#define COM15_RGB555    0x30  /* RGB555 output */
#define REG_COM16       0x41  /* Control 16 */
#define COM16_AWBGAIN   0x08  /* AWB gain enable */
#define REG_COM17       0x42  /* Control 17 */
#define COM17_AECWIN    0xc0  /* AEC window - must match COM4 */
#define COM17_CBAR      0x08  /* DSP Color bar */
/*
 * This matrix defines how the colors are generated, must be
 * tweaked to adjust hue and saturation.
 *
 * Order: v-red, v-green, v-blue, u-red, u-green, u-blue
 *
 * They are nine-bit signed quantities, with the sign bit
 * stored in 0x58.  Sign for v-red is bit 0, and up from there.
 */
#define REG_CMATRIX_BASE 0x4f
#define CMATRIX_LEN      6
#define REG_CMATRIX_SIGN 0x58
#define REG_BRIGHT       0x55  /* Brightness */
#define REG_CONTRAS      0x56  /* Contrast control */
#define REG_GFIX         0x69  /* Fix gain control */
#define REG_REG76        0x76  /* OV's name */
#define R76_BLKPCOR      0x80  /* Black pixel correction enable */
#define R76_WHTPCOR      0x40  /* White pixel correction enable */
#define REG_RGB444       0x8c  /* RGB 444 control */
#define R444_ENABLE      0x02  /* Turn on RGB444, overrides 5x5 */
#define R444_RGBX        0x01  /* Empty nibble at end */
#define REG_HAECC1       0x9f  /* Hist AEC/AGC control 1 */
#define REG_HAECC2       0xa0  /* Hist AEC/AGC control 2 */
#define REG_BD50MAX      0xa5  /* 50hz banding step limit */
#define REG_HAECC3       0xa6  /* Hist AEC/AGC control 3 */
#define REG_HAECC4       0xa7  /* Hist AEC/AGC control 4 */
#define REG_HAECC5       0xa8  /* Hist AEC/AGC control 5 */
#define REG_HAECC6       0xa9  /* Hist AEC/AGC control 6 */
#define REG_HAECC7       0xaa  /* Hist AEC/AGC control 7 */
#define REG_BD60MAX      0xab  /* 60hz banding step limit */




///////// Main Program //////////////
void setup() {
  Wire.begin();
  Serial.begin(9600);
  
delay(100);
OV7670_write_register( REG_COM7, COM7_RESET );
/*
 * Clock scale: 3 = 15fps
 *              2 = 20fps
 *              1 = 30fps
 */
 OV7670_write_register( REG_CLKRC, 0x40 );  /* OV: clock scale (30 fps) */
 OV7670_write_register( REG_TSLB,  0x04 ); /* OV */
 OV7670_write_register( REG_COM7, 0x00 ); /* VGA */
  /*
   * Set the hardware window.  These values from OV don't entirely
   * make sense - hstop is less than hstart.  But they work...
   */
  OV7670_write_register( REG_HSTART, 0x13 );  OV7670_write_register( REG_HSTOP, 0x01 );
  OV7670_write_register( REG_HREF, 0xb6 );  OV7670_write_register( REG_VSTART, 0x02 );
  OV7670_write_register( REG_VSTOP, 0x7a ); OV7670_write_register( REG_VREF, 0x0a );
  OV7670_write_register( REG_COM3, 0 ); OV7670_write_register( REG_COM14, 0 );
  /* Mystery scaling numbers */
  OV7670_write_register( 0x70, 0x3a );    OV7670_write_register( 0x71, 0x35 );
  OV7670_write_register( 0x72, 0x11 );    OV7670_write_register( 0x73, 0xf0 );
  OV7670_write_register( 0xa2, 0x02 );    OV7670_write_register( REG_COM10, 0x0 );
  /* Gamma curve values */
  OV7670_write_register( 0x7a, 0x20 );    OV7670_write_register( 0x7b, 0x10 );
  OV7670_write_register( 0x7c, 0x1e );    OV7670_write_register( 0x7d, 0x35 );
  OV7670_write_register( 0x7e, 0x5a );    OV7670_write_register( 0x7f, 0x69 );
  OV7670_write_register( 0x80, 0x76 );    OV7670_write_register( 0x81, 0x80 );
  OV7670_write_register( 0x82, 0x88 );    OV7670_write_register( 0x83, 0x8f );
  OV7670_write_register( 0x84, 0x96 );    OV7670_write_register( 0x85, 0xa3 );
  OV7670_write_register( 0x86, 0xaf );    OV7670_write_register( 0x87, 0xc4 );
  OV7670_write_register( 0x88, 0xd7 );    OV7670_write_register( 0x89, 0xe8 );
  /* AGC and AEC parameters.  Note we start by disabling those features,
     then turn them only after tweaking the values. */
  OV7670_write_register( REG_COM8, COM8_FASTAEC | COM8_AECSTEP | COM8_BFILT );
  OV7670_write_register( REG_GAIN, 0 ); OV7670_write_register( REG_AECH, 0 );
  OV7670_write_register( REG_COM4, 0x40 ); /* magic reserved bit */
  OV7670_write_register( REG_COM9, 0x18 ); /* 4x gain + magic rsvd bit */
  OV7670_write_register( REG_BD50MAX, 0x05 ); OV7670_write_register( REG_BD60MAX, 0x07 );
  OV7670_write_register( REG_AEW, 0x95 ); OV7670_write_register( REG_AEB, 0x33 );
  OV7670_write_register( REG_VPT, 0xe3 ); OV7670_write_register( REG_HAECC1, 0x78 );
  OV7670_write_register( REG_HAECC2, 0x68 );  OV7670_write_register( 0xa1, 0x03 ); /* magic */
  OV7670_write_register( REG_HAECC3, 0xd8 );  OV7670_write_register( REG_HAECC4, 0xd8 );
  OV7670_write_register( REG_HAECC5, 0xf0 );  OV7670_write_register( REG_HAECC6, 0x90 );
  OV7670_write_register( REG_HAECC7, 0x94 );
  OV7670_write_register( REG_COM8, COM8_FASTAEC|COM8_AECSTEP|COM8_BFILT|COM8_AGC|COM8_AEC );
  /* Almost all of these are magic "reserved" values.  */
  OV7670_write_register( REG_COM5, 0x61 );  OV7670_write_register( REG_COM6, 0x4b );
  OV7670_write_register( 0x16, 0x02 );    OV7670_write_register( REG_MVFP, 0x07 );
  OV7670_write_register( 0x21, 0x02 );    OV7670_write_register( 0x22, 0x91 );
  OV7670_write_register( 0x29, 0x07 );    OV7670_write_register( 0x33, 0x0b );
  OV7670_write_register( 0x35, 0x0b );    OV7670_write_register( 0x37, 0x1d );
  OV7670_write_register( 0x38, 0x71 );    OV7670_write_register( 0x39, 0x2a );
  OV7670_write_register( REG_COM12, 0x78 ); OV7670_write_register( 0x4d, 0x40 );
  OV7670_write_register( 0x4e, 0x20 );    OV7670_write_register( REG_GFIX, 0 );
  OV7670_write_register( 0x6b, 0x0b );    OV7670_write_register( 0x74, 0x10 );
  OV7670_write_register( 0x8d, 0x4f );    OV7670_write_register( 0x8e, 0 );
  OV7670_write_register( 0x8f, 0 );   OV7670_write_register( 0x90, 0 );
  OV7670_write_register( 0x91, 0 );   OV7670_write_register( 0x96, 0 );
  OV7670_write_register( 0x9a, 0 );   OV7670_write_register( 0xb0, 0x84 );
  OV7670_write_register( 0xb1, 0x0c );    OV7670_write_register( 0xb2, 0x0e );
  OV7670_write_register( 0xb3, 0x82 );    OV7670_write_register( 0xb8, 0x0a );
  /* More reserved magic, some of which tweaks white balance */
  OV7670_write_register( 0x43, 0x0a );    OV7670_write_register( 0x44, 0xf0 );
  OV7670_write_register( 0x45, 0x34 );    OV7670_write_register( 0x46, 0x58 );
  OV7670_write_register( 0x47, 0x28 );    OV7670_write_register( 0x48, 0x3a );
  OV7670_write_register( 0x59, 0x88 );    OV7670_write_register( 0x5a, 0x88 );
  OV7670_write_register( 0x5b, 0x44 );    OV7670_write_register( 0x5c, 0x67 );
  OV7670_write_register( 0x5d, 0x49 );    OV7670_write_register( 0x5e, 0x0e );
  OV7670_write_register( 0x6c, 0x0a );    OV7670_write_register( 0x6d, 0x55 );
  OV7670_write_register( 0x6e, 0x11 );    OV7670_write_register( 0x6f, 0x9f ); /* "9e for advance AWB" */
  OV7670_write_register( 0x6a, 0x40 );    OV7670_write_register( REG_BLUE, 0x40 );
  OV7670_write_register( REG_RED, 0x60 );
  OV7670_write_register( REG_COM8, COM8_FASTAEC|COM8_AECSTEP|COM8_BFILT|COM8_AGC|COM8_AEC|COM8_AWB );
  /* Matrix coefficients */
  OV7670_write_register( 0x4f, 0x80 );    OV7670_write_register( 0x50, 0x80 );
  OV7670_write_register( 0x51, 0 );   OV7670_write_register( 0x52, 0x22 );
  OV7670_write_register( 0x53, 0x5e );    OV7670_write_register( 0x54, 0x80 );
  OV7670_write_register( 0x58, 0x9e );
  OV7670_write_register( REG_COM16, COM16_AWBGAIN );  OV7670_write_register( REG_EDGE, 0 );
  OV7670_write_register( 0x75, 0x05 );    OV7670_write_register( 0x76, 0xe1 );
  OV7670_write_register( 0x4c, 0 );   OV7670_write_register( 0x77, 0x01 );
  OV7670_write_register( REG_COM13, 0xc3 ); OV7670_write_register( 0x4b, 0x09 );
  OV7670_write_register( 0xc9, 0x60 );    OV7670_write_register( REG_COM16, 0x38 );
  OV7670_write_register( 0x56, 0x40 );
  OV7670_write_register( 0x34, 0x11 );    OV7670_write_register( REG_COM11, COM11_EXP|COM11_HZAUTO );
  OV7670_write_register( 0xa4, 0x88 );    OV7670_write_register( 0x96, 0 );
  OV7670_write_register( 0x97, 0x30 );    OV7670_write_register( 0x98, 0x20 );
  OV7670_write_register( 0x99, 0x30 );    OV7670_write_register( 0x9a, 0x84 );
  OV7670_write_register( 0x9b, 0x29 );    OV7670_write_register( 0x9c, 0x03 );
  OV7670_write_register( 0x9d, 0x4c );    OV7670_write_register( 0x9e, 0x3f );
  OV7670_write_register( 0x78, 0x04 );
  /* Extra-weird stuff.  Some sort of multiplexor register */
  OV7670_write_register( 0x79, 0x01 );    OV7670_write_register( 0xc8, 0xf0 );
  OV7670_write_register( 0x79, 0x0f );    OV7670_write_register( 0xc8, 0x00 );
  OV7670_write_register( 0x79, 0x10 );    OV7670_write_register( 0xc8, 0x7e );
  OV7670_write_register( 0x79, 0x0a );    OV7670_write_register( 0xc8, 0x80 );
  OV7670_write_register( 0x79, 0x0b );    OV7670_write_register( 0xc8, 0x01 );
  OV7670_write_register( 0x79, 0x0c );    OV7670_write_register( 0xc8, 0x0f );
  OV7670_write_register( 0x79, 0x0d );    OV7670_write_register( 0xc8, 0x20 );
  OV7670_write_register( 0x79, 0x09 );    OV7670_write_register( 0xc8, 0x80 );
  OV7670_write_register( 0x79, 0x02 );    OV7670_write_register( 0xc8, 0xc0 );
  OV7670_write_register( 0x79, 0x03 );    OV7670_write_register( 0xc8, 0x40 );
  OV7670_write_register( 0x79, 0x05 );    OV7670_write_register( 0xc8, 0x30 );
  OV7670_write_register( 0x79, 0x26 );
  OV7670_write_register( 0xff, 0xff );  /* END MARKER */


   OV7670_write_register(REG_CLKRC, 0xc0); //use external clock


  OV7670_write_register( REG_COM7, COM7_RGB | COM7_FMT_QCIF);  /* Selects RGB mode */
  OV7670_write_register( REG_RGB444, R444_ENABLE | R444_RGBX ); /* Enable xxxxrrrr ggggbbbb */
  OV7670_write_register( REG_COM1, 0x0 ); /* CCIR601 */
  OV7670_write_register( REG_COM15, COM15_R01FE|COM15_RGB565 ); /* Data range needed? */
  OV7670_write_register( REG_COM9, 0x38 );  /* 16x gain ceiling; 0x8 is reserved bit */
  OV7670_write_register( 0x4f, 0xb3 );  /* "matrix coefficient 1" */
  OV7670_write_register( 0x50, 0xb3 );  /* "matrix coefficient 2" */
  OV7670_write_register( 0x51, 0    );    /* vb */
  OV7670_write_register( 0x52, 0x3d );  /* "matrix coefficient 4" */
  OV7670_write_register( 0x53, 0xa7 );  /* "matrix coefficient 5" */
  OV7670_write_register( 0x54, 0xe4 );  /* "matrix coefficient 6" */
  OV7670_write_register( REG_COM13, COM13_GAMMA|COM13_UVSAT|0x2 );  /* Magic rsvd bit */
  OV7670_write_register( 0xff, 0xff );
  OV7670_write_register(REG_COM3, 0x08); //enable scaling
  OV7670_write_register(0x1e, 0xe0); //vertical flip
  OV7670_write_register(REG_COM17, 0x00);
  
  //OV7670_write_register(0x6b, 0x0b);

}

void loop(){
  
 }


byte read_register_value(int register_address){
  byte data = 0;
  Wire.beginTransmission(OV7670_I2C_ADDRESS);
  Wire.write(register_address);
  Wire.endTransmission();
  Wire.requestFrom(OV7670_I2C_ADDRESS,1);
  //Serial.println("in read function");
  while(Wire.available()<1){
      //Serial.println("stuck");
    }
  data = Wire.read();
  //Serial.println("passed while loop");
  return data;
}

String OV7670_write(int start, const byte *pData, int size){
    int n,error;
    Wire.beginTransmission(OV7670_I2C_ADDRESS);
    n = Wire.write(start);
    if(n != 1){
      return "I2C ERROR WRITING START ADDRESS";   
    }
    n = Wire.write(pData, size);
    if(n != size){
      return "I2C ERROR WRITING DATA";
    }
    error = Wire.endTransmission(true);
    if(error != 0){
      return String(error);
    }
    return "no errors :)";
 }

String OV7670_write_register(int reg_address, byte data){
  return OV7670_write(reg_address, &data, 1);
 }
