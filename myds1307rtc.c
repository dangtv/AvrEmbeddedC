#include <myds1307rtc.h>

//Khoi dong TWI
unsigned char registry_ds1307[7]; // mang de luu tam cac gia tri doc duoc tu thanh ghi cua ds1307

void TWI_Init(void) {
    TWSR = 0x00; //Prescaler=1
    TWBR = _100K;
    TWCR = (1 << TWINT) | (1 << TWEN);
}

///chon dia chi thanh ghi can thao tac, dummy write
//Addr: dia thi thanh ghi can ghi

unsigned char TWI_DS1307_wadr(unsigned char Addr) {

    TWCR = TWI_START; //goi START condition
    while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
    if ((TWSR & 0xF8) != 0x08) return TWSR; //neu goi Start co loi thi thoat

    TWDR = (DS1307_SLA << 1) + TWI_W; //dia chi DS va bit W 	
    TWCR = TWI_Clear_TWINT; //xoa TWINT, bat dau goi SLA
    while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
    if ((TWSR & 0xF8) != 0x18) return TWSR; //device address send error, escape anyway

    TWDR = Addr; //goi dia chi thanh ghi can ghi vao
    TWCR = TWI_Clear_TWINT; //start send address by cleaning TWINT
    while ((TWCR & 0x80) == 0x00); //check and wait for TWINT bit=1
    if ((TWSR & 0xF8) != 0x28) return TWSR; //neu du lieu goi ko thanh cong thi thoat

    TWCR = TWI_STOP; //STOP condition
    return 0;
}

//ghi 1 mang dat vao DS
//Addr: dia thi thanh ghi can ghi
//Data[]: mang du lieu
//len: so luong byte can ghi

unsigned char TWI_DS1307_wblock(unsigned char Addr, unsigned char Data[], unsigned char len) {
    unsigned char i = 0;
    TWCR = TWI_START; //goi START condition
    while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
    if ((TWSR & 0xF8) != 0x08) return TWSR; //neu goi Start co loi thi thoat

    TWDR = (DS1307_SLA << 1) + TWI_W; //dia chi DS va bit W 	
    TWCR = TWI_Clear_TWINT; //xoa TWINT de bat dau goi
    while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
    if ((TWSR & 0xF8) != 0x18) return TWSR; //neu co loi truyen SLA, thoat

    TWDR = Addr; //goi dia chi thanh ghi can ghi vao
    TWCR = TWI_Clear_TWINT; //xoa TWINT de bat dau goi
    while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
    if ((TWSR & 0xF8) != 0x28) return TWSR;

    for (i = 0; i < len; i++) {
        TWDR = Data[i]; //chuan bi xuat du lieu
        TWCR = TWI_Clear_TWINT; //xoa TWINT, bat dau send
        while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
        if ((TWSR & 0xF8) != 0x28) return TWSR; //neu status ko phai la 0x28 thi return
    }

    TWCR = TWI_STOP; //STOP condition
    return 0;
}

//doc 1 mang tu DS

unsigned char TWI_DS1307_rblock(unsigned char Data[], unsigned char len) {
    unsigned char i;

    TWCR = TWI_START; // Start--------------------------------------------------------------------
    while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x08)); //cho TWINT bit=1 va goi START thanh cong

    TWDR = (DS1307_SLA << 1) + TWI_R; //goi dia chi SLA +READ	
    TWCR = TWI_Clear_TWINT; //bat dau, xoa TWINT
    while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x40)); //cho TWINT bit=1	va goi SLA thanh cong

    //nhan len-1 bytes dau tien---------------------
    for (i = 0; i < len - 1; i++) {
        TWCR = TWI_Read_ACK; //xoa TWINT,se goi ACK sau khi nhan moi byte
        while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x50)); //cho TWINT bit=1 hoac nhan duoc ACK	   
        Data[i] = TWDR; //doc du lieu vao mang Data 
    }
    //nhan byte cuoi
    TWCR = TWI_Clear_TWINT; //xoa TWINT de nhan byte cuoi, sau do set NOT ACK
    while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x58)); //cho TWIN=1 hoac trang thai not ack	
    Data[len - 1] = TWDR;

    TWCR = TWI_STOP; //STOP condition
    return 0;
}

//----------------------------------------------------------------------------
// xay dung lai cac ham ma khong dung thu vien

// doi BCD sang thap phan va nguoc lai------------

unsigned char BCD2Dec(unsigned char BCD) {
    unsigned char L, H;
    L = BCD & 0x0F;
    H = (BCD >> 4)*10;
    return (H + L);
}

unsigned char Dec2BCD(unsigned char Dec) {
    unsigned char L, H;
    L = Dec % 10;
    H = (Dec / 10) << 4;
    return (H + L);
}

Time myGetTimeFromDS1307() {
    Time time;
    time.Hour = 10;
    time.Minute = 15;
    //    return time;
    TWI_DS1307_wadr(0x00); //set dia chi ve 0
    delay_ms(1); //cho DS1307 xu li 
    TWI_DS1307_rblock(registry_ds1307, 7); //doc ca khoi thoi gian (7 bytes)

    time.Second = BCD2Dec(registry_ds1307[0] & 0x7F);
    time.Minute = BCD2Dec(registry_ds1307[1]);
    // mode lay tu bit 6 ( =0 la 24h; =1 la 12h)
    // mode = 0 la 24h, =1 la 12h
    time.Mode = ((registry_ds1307[2] & 0x40) != 0);
    // AM hay PM lay tu bit 5
    time.AP = ((registry_ds1307[2] & 0x20) != 0);
    if (time.Mode != 0) time.Hour = BCD2Dec(registry_ds1307[2] & 0x1F); //mode 12h
    else time.Hour = BCD2Dec(registry_ds1307[2] & 0x3F); //mode 24h	
    time.Date = BCD2Dec(registry_ds1307[4]);
    time.Month = BCD2Dec(registry_ds1307[5]);
    time.Year = BCD2Dec(registry_ds1307[6]);
    return time;
}

void mySetTimeForDS1307(Time * t) {
    registry_ds1307[0] = Dec2BCD(t->Second);

    registry_ds1307[1] = Dec2BCD(t->Minute);
    if (t->Mode != 0) // che do hien thi 12h
        // bit 7 = 0; bit 6 =1;(che do 12h), 0: che do 24h 
        //; bit 5 =0 -> AM, 1->PM
        //5bit con lai la ma BCD cua gio
        registry_ds1307[2] = Dec2BCD(t->Hour) | (t->Mode << 6) | (t->AP << 5); //mode 12h

    else
        // bit 7 = 0; bit 6 =0;(che do 24h) ; 
        registry_ds1307[2] = Dec2BCD(t->Hour); //mode 24h

    registry_ds1307[4] = Dec2BCD(t->Date);
    registry_ds1307[5] = Dec2BCD(t->Month);
    registry_ds1307[6] = Dec2BCD(t->Year);


    TWI_DS1307_wblock(0x00, registry_ds1307, 7); //doc ca khoi thoi gian (7 bytes)
    delay_ms(1); //cho DS1307 xu li 
}