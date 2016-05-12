// ---------------------------------------------------------------------------
// I2C (TWI) ROUTINES
//
// On the AVRmega series, PA4 is the data line (SDA) and PA5 is the clock (SCL
// The standard clock rate is 100 KHz, and set by I2C_Init. It depends on the AVR osc. freq.


#include <io.h>
#include <stdio.h>
#include <delay.h>

#define F_CPU 4000000L // I2C clock speed 100 KHz
#define F_SCL 100000L // I2C clock speed 100 KHz
#define READ 1
#define TW_START 0xA4 // send start condition (TWINT,TWSTA,TWEN)
#define TW_STOP 0x94 // send stop condition (TWINT,TWSTO,TWEN)
#define TW_ACK 0xC4 // return ACK to slave
#define TW_NACK 0x84 // don't return ACK to slave
#define TW_SEND 0x84 // send data (TWINT,TWEN)
#define TW_READY (TWCR & 0x80) // ready when TWINT returns to logic 1.
#define TW_STATUS (TWSR & 0xF8) // returns value of status register
#define I2C_Stop() TWCR = TW_STOP // inline macro for stop condition

typedef unsigned char byte;

void I2C_Init();

byte I2C_Detect(byte addr);

byte I2C_FindDevice(byte start);

void I2C_Start(byte slaveAddr);

byte I2C_Write(byte data) ;

byte I2C_ReadACK() ;

byte I2C_ReadNACK() ;

void I2C_WriteByte(byte busAddr, byte data);

void I2C_WriteRegister(byte busAddr, byte deviceRegister, byte data) ;

byte I2C_ReadRegister(byte busAddr, byte deviceRegister) ;
