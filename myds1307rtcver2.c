// ---------------------------------------------------------------------------
// I2C (TWI) ROUTINES
//
// On the AVRmega series, PA4 is the data line (SDA) and PA5 is the clock (SCL
// The standard clock rate is 100 KHz, and set by I2C_Init. It depends on the AVR osc. freq.
#include <myds1307rtcver2.h>




//void DS1307_GetTime(byte *hours, byte *minutes, byte *seconds)
//// returns hours, minutes, and seconds in BCD format
//{
//    *hours = I2C_ReadRegister(DS1307, HOURS_REGISTER);
//    *minutes = I2C_ReadRegister(DS1307, MINUTES_REGISTER);
//    *seconds = I2C_ReadRegister(DS1307, SECONDS_REGISTER);
//    if (*hours & 0x40) // 12hr mode:
//        *hours &= 0x1F; // use bottom 5 bits (pm bit = temp & 0x20)
//    else *hours &= 0x3F; // 24hr mode: use bottom 6 bits
//}
//
//void DS1307_GetDate(byte *months, byte *days, byte *years)
//// returns months, days, and years in BCD format
//{
//    *months = I2C_ReadRegister(DS1307, MONTHS_REGISTER);
//    *days = I2C_ReadRegister(DS1307, DAYS_REGISTER);
//    *years = I2C_ReadRegister(DS1307, YEARS_REGISTER);
//}
//
//void SetTimeDate()
//// simple, hard-coded way to set the date.
//{
//    I2C_WriteRegister(DS1307, MONTHS_REGISTER, 0x08);
//    I2C_WriteRegister(DS1307, DAYS_REGISTER, 0x31);
//    I2C_WriteRegister(DS1307, YEARS_REGISTER, 0x13);
//    I2C_WriteRegister(DS1307, HOURS_REGISTER, 0x08 + 0x40); // add 0x40 for PM
//    I2C_WriteRegister(DS1307, MINUTES_REGISTER, 0x51);
//    I2C_WriteRegister(DS1307, SECONDS_REGISTER, 0x00);
//}


unsigned char BCD2Decver2(unsigned char BCD) {
    unsigned char L, H;
    L = BCD & 0x0F;
    H = (BCD >> 4)*10;
    return (H + L);
}

unsigned char Dec2BCDver2(unsigned char Dec) {
    unsigned char L, H;
    L = Dec % 10;
    H = (Dec / 10) << 4;
    return (H + L);
}

Time myGetTimeFromDS1307ver2() {
    Time time;
    time.Hour = 10;
    time.Minute = 15;
    //    return time;

    time.Second = BCD2Decver2(I2C_ReadRegister(DS1307, SECONDS_REGISTER) & 0x7F);
    time.Minute = BCD2Decver2(I2C_ReadRegister(DS1307, MINUTES_REGISTER));
    // mode lay tu bit 6 ( =0 la 24h; =1 la 12h)
    // mode = 0 la 24h, =1 la 12h
    time.Mode = ((I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x40) != 0);
    // AM hay PM lay tu bit 5
    time.AP = ((I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x20) != 0);
    if (time.Mode != 0) time.Hour = BCD2Decver2(I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x1F); //mode 12h
    else time.Hour = BCD2Decver2(I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x3F); //mode 24h	
    time.Day = BCD2Decver2(I2C_ReadRegister(DS1307, DAYOFWK_REGISTER));
    time.Date = BCD2Decver2(I2C_ReadRegister(DS1307, DAYS_REGISTER));
    time.Month = BCD2Decver2(I2C_ReadRegister(DS1307, MONTHS_REGISTER));
    time.Year = BCD2Decver2(I2C_ReadRegister(DS1307, YEARS_REGISTER));
    return time;
}

void mySetTimeForDS1307ver2(Time * t) {
    I2C_WriteRegister(DS1307, SECONDS_REGISTER, Dec2BCDver2(t->Second));

    I2C_WriteRegister(DS1307, MINUTES_REGISTER,  Dec2BCDver2(t->Minute));
    if (t->Mode != 0) // che do hien thi 12h
        // bit 7 = 0; bit 6 =1;(che do 12h), 0: che do 24h 
        //; bit 5 =0 -> AM, 1->PM
        //5bit con lai la ma BCD cua gio
        I2C_WriteRegister(DS1307, HOURS_REGISTER, Dec2BCDver2(t->Hour) | (t->Mode << 6) | (t->AP << 5)); //mode 12h

    else
        // bit 7 = 0; bit 6 =0;(che do 24h) ; 
        I2C_WriteRegister(DS1307, HOURS_REGISTER, Dec2BCDver2(t->Hour)); //mode 24h

    I2C_WriteRegister(DS1307, DAYOFWK_REGISTER, Dec2BCDver2(t->Day));
    I2C_WriteRegister(DS1307, DAYS_REGISTER, Dec2BCDver2(t->Date));
    I2C_WriteRegister(DS1307, MONTHS_REGISTER, Dec2BCDver2(t->Month));
    I2C_WriteRegister(DS1307, YEARS_REGISTER, Dec2BCDver2(t->Year));
}