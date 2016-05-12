#include <myi2c.h>

// DS1307 RTC ROUTINES
#define DS1307 0xD0 // I2C bus address of DS1307 RTC
#define SECONDS_REGISTER 0x00
#define MINUTES_REGISTER 0x01
#define HOURS_REGISTER 0x02
#define DAYOFWK_REGISTER 0x03
#define DAYS_REGISTER 0x04
#define MONTHS_REGISTER 0x05
#define YEARS_REGISTER 0x06
#define CONTROL_REGISTER 0x07
#define RAM_BEGIN 0x08
#define RAM_END 0x3F

//typedef unsigned char byte;
struct Time {
    //Mode: chon che do 12h hoac 24h, Mode nam o bit 6 cua thanh ghi HOURS, 
    //Mode=1: 12H, Mode=0: 24H
    //AP: bien chi AM hoac PM trong Mode 12h, AP nam o bit 5 cua thang ghi HOURS, 
    //AP=1:PM, AP=0: AM
    unsigned char Second, Minute, Hour, Day, Date, Month, Year, Mode, AP; // mode(che do hien thi) =0 -> 24h; 1->12h
};
typedef struct Time Time;




Time myGetTimeFromDS1307ver2();
void mySetTimeForDS1307ver2(Time * _t);