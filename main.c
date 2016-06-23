/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.6 Evaluation
Automatic Program Generator
ï¿½ Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <io.h>
#include <interrupt.h>

#define IS_MASTER 1
#define MY_ADDRESS '2'
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


// Declare your global variables here
unsigned char ma[] = {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
void quet(unsigned char x);
void day();
void hienthi(int x);

void hienthinhietdo(unsigned char temp);
void hienthithoigian(unsigned char hour, unsigned char minute);

void uart_char_tx(unsigned char chr);
void uart_address_tx(unsigned char chr);
unsigned char uart_getchar();
void getState(unsigned char);
void process_received_data();

float temp;
unsigned char kytu = '';
unsigned char b = 2;
unsigned char received_byte = '';
unsigned char received_package[10];
int isComplete = 1;
int package_size = 0;
int slave_enable = 0;

byte ttemp0; // first byte
byte ttemp1;

void execute_query();
void send_confirm_to_master();
void disable_slave();
void ensable_slave();
// thuc thi cau lenh doc tu goi tin (package))

void return_data_to_master(unsigned char d1, unsigned char d2, unsigned char d3, unsigned char d4, unsigned char d5) {
    uart_char_tx('@');
    delay_ms(100);
    uart_char_tx(d1); //printf("%d",d1);
    delay_ms(100);
    uart_char_tx(d2);//printf("%d",d2);
    delay_ms(100);
    uart_char_tx(d3);//printf("%d",d3);
    delay_ms(100);
    uart_char_tx(d4);//printf("%d",d4);
    delay_ms(100);
    uart_char_tx(d5);//printf("%d",d5);
    delay_ms(100);
    uart_char_tx('#');
    delay_ms(100);
    disable_slave();
}

void return_data_to_computer(unsigned char d1, unsigned char d2, unsigned char d3, unsigned char d4, unsigned char d5){
    hienthi(111);delay_ms(3000);
    uart_char_tx('&'); 
    delay_ms(100);
    uart_char_tx(d1);hienthi(d1);delay_ms(2000);
    delay_ms(100);
    uart_char_tx(d2);hienthi(d2);delay_ms(2000);
    delay_ms(100);
    uart_char_tx(d3);hienthi(d3);delay_ms(2000);
    delay_ms(100);
    uart_char_tx(d4);hienthi(d4);delay_ms(2000);
    delay_ms(100);
    uart_char_tx(d5);hienthi(d5);delay_ms(2000);
    delay_ms(100);
    uart_char_tx('#');
    delay_ms(100);

}

void execute_query() {
    Time t;

    if (IS_MASTER) {
        hienthi(package_size); delay_ms(4000);
        // thuc hien cau truy van nhan duoc tren master
        if (package_size == 4) { // co the nhan biet bang byte dau tien khac 0
            // gui dia chi cho slave, sau do cho xac nhan tu slave
            uart_address_tx(received_package[1]);
            //            if (received_package[2] == 't') {
            //                //printf ("%c",a);
            //                temp = ds18b20_gettemp();
            //                uart_char_tx('T');
            //                printf(" Nhiet do hien tai la %d oC\n\r", (unsigned char) temp);
            //
            //            }
            //            if (received_package[2] == 'h') {
            //                t = myGetTimeFromDS1307ver2();
            //                printf(" Gio hien tai la %d:%d:%d\n\r", (unsigned char) (t.Hour + t.Mode * t.AP * 12), (unsigned char) t.Minute, (unsigned char) t.Second);
            //
            //            }

        }
        if(package_size == 7) { // co the nhan biet goi tin data bang byte dau tien luon =0
            // day la goi tin data
            // nhan biet nhiet do hay thoi gian dua vao byte so 3 = 0 hay khac 0
            hienthi(55);delay_ms(4000);
            if(received_package[2] ==0){
                // day la goi nhiet do
                temp = received_package[4]+received_package[5]/10;
                return_data_to_computer(0, 0, 0,received_package[4],received_package[5]);
            }
            if(received_package[2] == 1){
                // day la goi thoi gian
                t.Hour = received_package[3];
                t.Minute = received_package[4];
                t.Second = received_package[5];
                return_data_to_computer(0,1,received_package[3],received_package[4],received_package[5]);
            }
        }
    } else {
        // thuc hien cau truy van nhan duoc tren slave
        if (package_size == 4) {
            if (received_package[2] == 't') {
                //printf ("%c",a);
                temp = ds18b20_gettemp();
                //printf("%d", (int)temp);
                //printf ("%d",temp);
                return_data_to_master(0, 0, 0,(unsigned char) ((int) temp), (unsigned char)((int) (10 * (temp - (int) temp))));

            }
            if (received_package[2] == 'h') {
                t = myGetTimeFromDS1307ver2();
                //printf(" Gio hien tai la %d:%d:%d\n\r", (unsigned char) (t.Hour + t.Mode * t.AP * 12), (unsigned char) t.Minute, (unsigned char) t.Second);
                return_data_to_master(0, 1, (t.Hour + t.Mode * t.AP * 12), t.Minute, t.Second);
            }

        }
    }
    package_size = 0;
}

void send_query_to_slave() {
//    hienthi(11);delay_ms(4000);
    uart_char_tx(received_package[0]);
    delay_ms(100); // cho cho master nhan va xu ly
    uart_char_tx(received_package[1]);
    delay_ms(100);
    uart_char_tx(received_package[2]);
    delay_ms(100);
    uart_char_tx(received_package[3]);
    delay_ms(100);
}

// doc tung byte va luu vao goi tin theo dinh dang

void process_received_data() {
    if (IS_MASTER) {
        // xu ly du lieu nhan duoc tren master
        if (isComplete) {
            if (received_byte == '@') {
                //hienthi(33);delay_ms(4000);
                //printf("bat dau goi tin; ");
                isComplete = 0;
                received_package[package_size] = received_byte;
                package_size++;
            }
            if (received_byte == '$') {
                // slave da xac nhan, xu ly tiep, gui cau truy van toi slave
                hienthi(11);delay_ms(4000);
                send_query_to_slave();
            }
        } else {
            received_package[package_size] = received_byte;
            package_size++;
            //hienthi(package_size);delay_ms(4000);
            if ((received_byte == '#') || (package_size > 9)) {
                //printf("ket thuc goi tin; ");
                //hienthi(44);delay_ms(4000);
                isComplete = 1;
                execute_query();
            }
        }
    } else {
        // xu ly du lieu nhan duoc tren slave
        if (isComplete) {
            if (received_byte == '@') {
                //printf("bat dau goi tin; ");
                isComplete = 0;
                received_package[package_size] = received_byte;
                package_size++;
            }
        } else {
            received_package[package_size] = received_byte;
            package_size++;
            if ((received_byte == '#') || (package_size > 9)) {
                //printf("ket thuc goi tin; ");
                isComplete = 1;
                execute_query();
            }
        }
    }
}

void send_confirm_to_master() {
    uart_char_tx('$');
}

void enable_slave() {
    slave_enable = 1;
    UCSRA &= ~(1 << MPCM);
}

void disable_slave() {
    slave_enable = 0;
    UCSRA |= (1 << MPCM);
}

// xu ly ngat nhan du lieu

interrupt [USART_RXC] void usart_rx_isr(void) {
    if (IS_MASTER) {
        // xu ly ngat nhan du lieu tren master
        received_byte = UDR;
        process_received_data();
    } 
    else {
        //xu ly ngat nhan du lieu tren slave
        //printf("slave nhan dia chi");
//        hienthi(received_byte);
//        delay_ms(6000);
        received_byte = UDR;
        if (slave_enable) {
            //printf("xy ly nghat");
            process_received_data();
        } else {
            //printf("slave nhan dia chi");
            if (MY_ADDRESS == received_byte) {
                enable_slave();
                send_confirm_to_master();
            }
        }
    }
}

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
    UCSRB = (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << UCSZ2);
    UBRRH = 0x00;
    UBRRL = 0x19;
    if(!IS_MASTER) disable_slave();

    
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
//        time = myGetTimeFromDS1307ver2();
//        hienthithoigian(time.Hour + time.Mode * time.AP * 12, time.Minute); // hien thi theo 24h
        hienthi(10);
        delay_ms(2000);
        
//        uart_char_tx('@');
//        delay_ms(100);
//        uart_char_tx('2');
//        delay_ms(100);
//        uart_char_tx('t');
//        delay_ms(100);
//        uart_char_tx('#');
//        delay_ms(100);

        // kytu = mygetchar();
        // if(kytu !=0) putchar(kytu);
        // printf("%c", my_variable);
        //printf("Nhiet do hien tai la"); 
        //kytu = uart_getchar(); 
        received_package[0] = '@';
        received_package[1]='2';
        received_package[2]='t';
        received_package[3]='#';
        uart_address_tx(received_package[1]);



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

    quet(ma[d]);
    quet(ma[c]);
    quet(ma[b]);
    quet(ma[a]);
    
    
    

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

void uart_char_tx(unsigned char chr) {
    while (!(UCSRA & (1 << UDRE))); //cho den khi bit UDRE=1 moi thoat khoi while
    UCSRB &= ~(1 << TXB8); //reset the 9th bit
    UDR = chr;
}

//chuong trinh con phat dia chi

void uart_address_tx(unsigned char chr) {
    while (!(UCSRA & (1 << UDRE))); //cho den khi bit UDRE=1 moi thoat khoi while
    UCSRB |= (1 << TXB8);
    UDR = chr;
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


