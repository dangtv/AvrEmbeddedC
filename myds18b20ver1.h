#include <io.h>
#include <mega16.h>
#include <stdlib.h>
#include <stdio.h>
#include <delay.h>
#define THERM_PORT PORTB
#define THERM_DDR DDRB
#define THERM_PIN PINB
#define THERM_IO 0

#define _BV(bit)  (1 << (bit))

#define ClearBit(x,y) x &= ~_BV(y) // equivalent to cbi(x,y)
#define SetBit(x,y) x |= _BV(y) // equivalent to sbi(x,y)
#define ReadBit(x,y) x & _BV(y) // call with PINx and bit#

#define THERM_INPUT() ClearBit(THERM_DDR,THERM_IO) // make pin an input
#define THERM_OUTPUT() SetBit(THERM_DDR,THERM_IO) // make pin an output
#define THERM_LOW() ClearBit(THERM_PORT,THERM_IO) // take (output) pin low
#define THERM_HIGH() SetBit(THERM_PORT,THERM_IO) // take (output) pin high
#define THERM_READ() ReadBit(THERM_PIN,THERM_IO) // get (input) pin value

#define THERM_CONVERTTEMP 0x44
#define THERM_READSCRATCH 0xBE
#define THERM_WRITESCRATCH 0x4E
#define THERM_COPYSCRATCH 0x48
#define THERM_READPOWER 0xB4
#define THERM_SEARCHROM 0xF0
#define THERM_READROM 0x33
#define THERM_MATCHROM 0x55
#define THERM_SKIPROM 0xCC
#define THERM_ALARMSEARCH 0xEC

typedef unsigned char byte;

byte therm_Reset();
void therm_WriteBit(byte _bit);


byte therm_ReadBit();
void therm_WriteByte(byte _data);
byte therm_ReadByte();
void therm_MatchRom(byte _rom[]);
void therm_ReadTempRaw(byte id[], byte *_t0, byte *_t1);

void therm_ReadTempC(byte id[], int *_whole, int *_decimal);
void therm_ReadTempF(byte id[], int *_whole, int *_decimal);
//inline __attribute__((gnu_inline)) void quickDelay(int _delay);
byte RomReaderProgram();