/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.6 Evaluation
Automatic Program Generator
� Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com




Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 4.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
 *****************************************************/

#include <mega16.h>


//#include <myds1307rtc.h>
#include <myds1307rtcver2.h>


//#include <myds18b20ver1.h>
#include <myds18b20ver2.h>


// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include <string.h>

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index, rx_rd_index, rx_counter;
#else
unsigned int rx_wr_index, rx_rd_index, rx_counter;
#endif
// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;
// USART Receiver interrupt service routine

interrupt [USART_RXC] void usart_rx_isr(void) {
    char status, data;
    status = UCSRA;
    data = UDR;
    if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN)) == 0) {
        rx_buffer[rx_wr_index] = data;
        if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index = 0;
        if (++rx_counter == RX_BUFFER_SIZE) {
            rx_counter = 0;
            rx_buffer_overflow = 1;
        };
    };
}

// Declare your global variables here
unsigned char ma[] = {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
void quet(unsigned char x);
void day();
void hienthi(int x);

void hienthinhietdo(unsigned char temp);
void hienthithoigian(unsigned char hour, unsigned char minute);

void uart_char_tx(unsigned char chr);
unsigned char uart_getchar();
void getState(unsigned char);


float temp;
unsigned char kytu = '';
unsigned char b = 2;

byte ttemp0; // first byte
byte ttemp1;

char mygetchar(void) {
    char data;
    if (rx_counter == 0) return 0;
    data = rx_buffer[rx_rd_index];
    if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index = 0;
    //#asm("cli")
    --rx_counter;
    //#asm("sei")
    return data;
}

// Declare your global variables here
unsigned char my_variable;

void main(void) {
    // Declare your local variables here
    unsigned char *t = 0;
    unsigned char h, m, s, i;
    int x;
    Time time = {30, 15, 10, 5, 12, 5, 16, 1, 1}; // thoi gian hien tai
    // Input/Output Ports initialization
    // Port A initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTA = 0x00;
    //    DDRA = 0x00;
    DDRA = 0xFF;

    // Port B initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTB = 0x00;
    DDRB = 0x00;

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTC = 0x00;
    //    DDRC = 0xFF;
    DDRC = 0x00;

    // Port D initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
    PORTD = 0x00;
    DDRD = 0x00;

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    TCCR0 = 0x00;
    TCNT0 = 0x00;
    OCR0 = 0x00;

    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: Timer1 Stopped
    // Mode: Normal top=0xFFFF
    // OC1A output: Discon.
    // OC1B output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer1 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A = 0x00;
    TCCR1B = 0x00;
    TCNT1H = 0x00;
    TCNT1L = 0x00;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: Timer2 Stopped
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    ASSR = 0x00;
    TCCR2 = 0x00;
    TCNT2 = 0x00;
    OCR2 = 0x00;

    // External Interrupt(s) initialization
    // INT0: Off
    // INT1: Off
    // INT2: Off
    MCUCR = 0x00;
    MCUCSR = 0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK = 0x00;

    // USART initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART Receiver: On
    // USART Transmitter: On
    // USART Mode: Asynchronous
    // USART Baud Rate: 9600
    UCSRA = 0x00;
    UCSRC = (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0);
    UCSRB = (1 << RXEN) | (1 << TXEN) | (1 << RXCIE);
    UBRRH = 0x00;
    UBRRL = 0x19;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR = 0x80;
    SFIOR = 0x00;

    // ADC initialization
    // ADC disabled
    ADCSRA = 0x00;

    // SPI initialization
    // SPI disabled
    SPCR = 0x00;

    // TWI initialization
    // TWI disabled
    TWCR = 0x00;

    // I2C Bus initialization
    // I2C Port: PORTA
    // I2C SDA bit: 1
    // I2C SCL bit: 0
    // Bit Rate: 100 kHz
    // Note: I2C settings are specified in the
    // Project|Configure|C Compiler|Libraries|I2C menu.
    //    i2c_init();

    // 1 Wire Bus initialization
    // 1 Wire Data port: PORTB
    // 1 Wire Data bit: 0
    // Note: 1 Wire port settings are specified in the
    // Project|Configure|C Compiler|Libraries|1 Wire menu.
    //    w1_init();
    //    ds18b20_init(t, 0, 0, DS18B20_9BIT_RES);
    //    rtc_init(0, 0, 0);

    //    TWI_Init(); //khoi dong TWI dung cho myds1307rtc.h
    I2C_Init(); //khoi dong TWI dung cho myds1307rtcver2.h

    // Global enable interrupts
#asm("sei")

    while (1) {

        // nhiet do
        int whole = 0, decimal = 0;

        // hien thi nhiet do su dung myds18b20ver1.h
        //        therm_ReadTempC(NULL, &whole, &decimal);
        //        hienthinhietdo(whole);

        // hien thi nhiet do su dung myds18b20ver2.h
        temp = ds18b20_gettemp();
        hienthinhietdo(temp);

        delay_ms(1000);

        //        temp = ds18b20_temperature(t);

        // lay thoi gian
        //        mySetTimeForDS1307ver2(&time);
        //        time = myGetTimeFromDS1307();
        time = myGetTimeFromDS1307ver2();
        hienthithoigian(time.Hour + time.Mode * time.AP * 12, time.Minute); // hien thi theo 24h
        delay_ms(2000);

        
        kytu = mygetchar();
        // if(kytu !=0) putchar(kytu);
        // printf("%c", my_variable);
        //printf("Nhiet do hien tai la"); 
        //kytu = uart_getchar();  

        if (kytu == 't') {
            //printf ("%c",a);
            printf(" Nhiet do hien tai la %d oC\n\r", (unsigned char) temp);

        }
        if (kytu == 'h') {
            printf(" Gio hien tai la %d:%d:%d\n\r", (unsigned char) (time.Hour + time.Mode * time.AP * 12), (unsigned char) time.Minute, (unsigned char) time.Second);

        }


    }
}

void hienthinhietdo(unsigned char temp) {
    unsigned char a, b;
    a = temp / 10;
    b = temp % 10;


    quet(0xC6);
    quet(0x9C);
    quet(ma[b]);
    quet(ma[a]);
    day(); // push
}

void hienthithoigian(unsigned char hour, unsigned char minute) {
    unsigned char a, b, c, d;
    a = hour / 10;
    b = hour % 10;
    c = minute / 10;
    d = minute % 10;
    quet(ma[d]);
    quet(ma[c]);
    quet(~(~ma[b] | 0x80));
    quet(ma[a]);
    day();
}

void hienthi(int x) {
    unsigned char a, b, c, d;
    int i = 0;
    a = x / 1000;
    b = (x % 1000) / 100;
    c = (x % 100) / 10;
    d = (x % 10);

    quet(ma[a]);
    quet(ma[b]);
    quet(ma[c]);
    quet(ma[d]);

    day();
}

void quet(unsigned char x) {
    unsigned char i, temp;
    for (i = 0; i < 8; i++) {
        temp = x;
        temp = temp & 0x80;
        if (temp == 0x80) {
            PORTA.1 = 1;
        } else {
            PORTA.1 = 0;
        }
        x = x * 2;
        PORTA.0 = 0;
        PORTA.0 = 1;
    }
}

void day() {
    PORTA.2 = 0;
    PORTA.2 = 1;
}

//chuong trinh con phat du lieu
void uart_char_tx(unsigned char chr){	
	while ( !( UCSRA & (1<<UDRE))) ; //cho den khi bit UDRE=1 moi thoat khoi while
	UDR=chr;
}

unsigned char uart_getchar() {
    unsigned char a = '';
    a = UDR;
    return a;
}

void getState(unsigned char a) {
    switch (a) {
        case 't':
            printf("Nhiet do hien tai la %f", temp);
            break;
        case 'h':
            printf("xin chao");
            break;
    }
}

//interrupt [USART_RXC] void rx_isr(){ //ngat nhan khi bit RXC =1
//  kytu = UDR; 
//}


