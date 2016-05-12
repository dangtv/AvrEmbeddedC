#include <myds18b20ver1.h>

// the following arrays specify the addresses of *my* ds18b20 devices
// substitute the address of your devices before using.

//byte rom0[] = {0x28, 0xE1, 0x21, 0xA3, 0x02, 0x00, 0x00, 0x5B};
//byte rom1[] = {0x28, 0x1B, 0x21, 0x30, 0x05, 0x00, 0x00, 0xF5};

byte therm_Reset() {
    byte i;
    THERM_OUTPUT(); // set pin as output
    THERM_LOW(); // pull pin low for 480uS
    delay_us(480);
    THERM_INPUT(); // set pin as input
    delay_us(60); // wait for 60uS
    i = THERM_READ(); // get pin value
    delay_us(420); // wait for rest of 480uS period
    return i;
}

void therm_WriteBit(byte _bit) {
    THERM_OUTPUT(); // set pin as output
    THERM_LOW(); // pull pin low for 1uS
    delay_us(1);
    if (_bit) THERM_INPUT(); // to write 1, float pin
    delay_us(60);
    THERM_INPUT(); // wait 60uS & release pin
}

byte therm_ReadBit() {
    byte _bit = 0;
    THERM_OUTPUT(); // set pin as output
    THERM_LOW(); // pull pin low for 1uS
    delay_us(1);
    THERM_INPUT(); // release pin & wait 14 uS
    delay_us(14);
    if (THERM_READ()) _bit = 1; // read pin value
    delay_us(45); // wait rest of 60uS period
    return _bit;
}

void therm_WriteByte(byte data) {
    byte i = 8;
    while (i--) // for 8 bits:
    {
        therm_WriteBit(data & 1); // send least significant bit
        data >>= 1; // shift all bits right
    }
}

byte therm_ReadByte() {
    byte i = 8, data = 0;
    while (i--) // for 8 bits:
    {
        data >>= 1; // shift all bits right
        data |= (therm_ReadBit() << 7); // get next bit (LSB first)
    }
    return data;
}

//void therm_MatchRom(byte rom[]) {
//    byte i;
//    therm_WriteByte(THERM_MATCHROM);
//    for (i = 0; i < 8; i++)
//        therm_WriteByte(rom[i]);
//}

void therm_ReadTempRaw(byte id[], byte *t0, byte *t1)
// Returns the two temperature bytes from the scratchpad
{
//    therm_Reset(); // skip ROM & start temp conversion

    //    if (id) therm_MatchRom(id);
    //    else therm_WriteByte(THERM_SKIPROM);
    //    therm_WriteByte(THERM_CONVERTTEMP);
    //    while (!therm_ReadBit()); // wait until conversion completed
    //    therm_Reset(); // read first two bytes from scratchpad
    //    if (id) therm_MatchRom(id);
    //    else therm_WriteByte(THERM_SKIPROM);

    therm_Reset(); // skip ROM & start temp conversion
    therm_WriteByte(THERM_SKIPROM);
    therm_WriteByte(THERM_CONVERTTEMP);
    while (!therm_ReadBit()); // wait until conversion completed
    
    therm_Reset(); // read first two bytes from scratchpad
    therm_WriteByte(THERM_SKIPROM);

    therm_WriteByte(THERM_READSCRATCH);
    *t0 = therm_ReadByte(); // first byte
    *t1 = therm_ReadByte(); // second byte
}

void therm_ReadTempC(byte id[], int *whole, int *decimal)
// returns temperature in Celsius as WW.DDDD, where W=whole & D=decimal
{
    byte t0, t1;
    therm_ReadTempRaw(id, &t0, &t1); // get temperature values
    *whole = (t1 & 0x07) << 4; // grab lower 3 bits of t1
    *whole |= t0 >> 4; // and upper 4 bits of t0
    *decimal = t0 & 0x0F; // decimals in lower 4 bits of t0
    *decimal *= 625; // conversion factor for 12-bit resolution
}

void therm_ReadTempF(byte id[], int *whole, int *decimal)
// returns temperature in Fahrenheit as WW.D, where W=whole & D=decimal
{
    byte t0, t1;
    int t16, t2, f10;
    therm_ReadTempRaw(id, &t0, &t1); // get temperature values
    t16 = (t1 << 8) + t0; // result is temp*16, in celcius
    t2 = t16 / 8; // get t*2, with fractional part lost
    f10 = t16 + t2 + 320; // F=1.8C+32, so 10F = 18C+320 = 16C + 2C + 320
    *whole = f10 / 10; // get whole part
    *decimal = f10 % 10; // get fractional part
}

//inline __attribute__((gnu_inline)) void quickDelay(int delay)
//// this routine will pause 0.25uS per delay unit
//// for testing only; use _us_Delay() routine for >1uS delays
//{
//    while (delay--) // uses sbiw to subtract 1 from 16bit word
//        asm volatile("nop"); // nop, sbiw, brne = 4 cycles = 0.25 uS
//}

// ---------------------------------------------------------------------------
// ROM READER PROGRAM

byte RomReaderProgram()
// Read the ID of the attached Dallas 18B20 device
// Note: only ONE device should be on the bus.
{
    byte i;
    byte data;
    //    LCD_String("ID (ROM) Reader:");
//    while (1) {
        //        LCD_Line(1);
        // write 64-bit ROM code on first LCD line
        therm_Reset();
        therm_WriteByte(THERM_READROM);
//        for (i = 0; i < 8; i++) {
            data = therm_ReadByte();
            //            LCD_HexByte(data);
//        }
        //        msDelay(1000); // do a read every second
//    }
        return data;
}