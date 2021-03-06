    /*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 2015/5/1
Author  : henry1758f@gmail.com
Company : KUAS EE501
Comments:


Chip type               : AT90S8535
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <90s8535.h>

// Alphanumeric LCD functions
#include <alcd.h>

#include <delay.h>
/*TIMER SETTING CONFIG DEFINE*/
#define STOP 0x00
#define FOSC1 0x01
#define FOSC8 0x02
#define FOSC64 0x03
#define FOSC256 0x04
#define FOSC1024 0x05
/*TIMER0 SET*/
#define T0SET FOSC8


int Year=2015,microSecond=0,sysclk=0;
unsigned char Month=12,Day=31,Hour=23,Minute=59,Second=55;
unsigned char lcd_loc[9][2]={{0,0},{2,0},{7,0},{10,0},{0,1},{2,1},{5,1},{8,1},{11,1}};
unsigned char onum[4],o2num[2];

void output_time();
void output_day();
void decoder(unsigned int inum);
void d2ecoder(unsigned int);
unsigned char value2char(unsigned char);
void caculate();
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here

}

// Timer 0 overflow interrupt service routine
#define ADDIV 38
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    sysclk++;
    microSecond=sysclk/ADDIV;
    //Second=sysclk/ADDIV;
    //Second++;
    if(sysclk%ADDIV==0)
    {
        PORTA=0x01;
        PORTA=0x00;

    }
    TCNT0=0x44;
    //caculate();
}


// Declare your global variables here

void main(void)
{
// Declare your local variables here


// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x01;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x40;
DDRD=0x40;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
TCCR0=STOP;
TCNT0=0x00;

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
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Rising Edge
// INT1: Off
GIMSK=0x40;
MCUCR=0x03;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// UART initialization
// UART disabled
UCR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;

// ADC initialization
// ADC disabled
ADCSR=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 5
// RD - PORTD Bit 4
// EN - PORTD Bit 0
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

    lcd_gotoxy(0,0);
    lcd_putsf("This is a clock!");
    lcd_gotoxy(3,1);
    lcd_putsf("Verison 0.1");
    delay_ms(3000);
    lcd_clear();
    delay_ms(1000);
    lcd_gotoxy(0,0);
    lcd_putsf("AD1999/12/31");
    lcd_gotoxy(3,1);
    lcd_putsf("00:00\'00\"0000");
    output_day();
    TCCR0=T0SET;
      while (1)
      {
      // Place your code here
         delay_ms(8);
         caculate();
         //output_time();
      }
}

void output_time()
{
    unsigned char i;
    lcd_gotoxy(0,1);
    lcd_putsf("   ");
    lcd_gotoxy(3,1); //hour
    d2ecoder(Hour);
    lcd_puts(o2num);
    lcd_gotoxy(5,1);
    lcd_putchar(':');
    lcd_gotoxy(6,1); //minute
    d2ecoder(Minute);
    lcd_puts(o2num);
    lcd_gotoxy(8,1);
    lcd_putchar('\'');
    lcd_gotoxy(9,1); //second
    d2ecoder(Second);
    lcd_puts(o2num);
    lcd_gotoxy(11,1);
    lcd_putsf("     ");

    /*
    lcd_putchar('\"');
    lcd_gotoxy(12,1); //microsecond
    d2ecoder(microSecond);
    lcd_puts(o2num);
      */


}

void output_day()
{
    lcd_gotoxy(0,0);
    lcd_putsf("AD");
    lcd_gotoxy(2,0); //Year
    decoder(Year);
    lcd_puts(onum);
    lcd_gotoxy(6,0);
    lcd_putchar('//');
    lcd_gotoxy(7,0); //Month
    d2ecoder(Month);
    lcd_puts(o2num);
    lcd_gotoxy(9,0);
    lcd_putchar('//');
    lcd_gotoxy(10,0); //Day
    d2ecoder(Day);
    lcd_puts(o2num);
    lcd_gotoxy(12,0);
    lcd_putsf("    ");
}

void decoder(unsigned int inum)
{
    unsigned char i;
    if(inum<10)
    {
        onum[3]=inum;
        onum[2]=0x00;
        onum[1]=0x00;
        onum[0]=0x00;
    }
    else if(inum<100 && inum>=10)
    {
        onum[3]=inum%10;
        inum=(inum-inum%10)/10;
        onum[2]=inum%10;
        onum[1]=0x00;
        onum[0]=0x00;
    }
    else if(inum<1000 && inum>=100)
    {
        onum[3]=inum%10;
        inum=(inum-inum%10)/10;
        onum[2]=inum%10;
        inum=(inum-inum%10)/10;
        onum[1]=inum%10;
        onum[0]=0x00;
    }
    else if(inum<10000 && inum>=1000)
    {
        onum[3]=inum%10;
        inum=(inum-inum%10)/10;
        onum[2]=inum%10;
        inum=(inum-inum%10)/10;
        onum[1]=inum%10;
        inum=(inum-inum%10)/10;
        onum[0]=inum%10;
    }
    for(i=0;i<4;i++)
    {
        onum[i]=value2char(onum[i]);
    }
    return;
}

void d2ecoder(unsigned int inum)
{
    unsigned char i;
    if(inum<10)
    {
        o2num[1]=inum;
        o2num[0]=0x00;

    }
    else if(inum<100 && inum>=10)
    {
        o2num[1]=inum%10;
        inum=(inum-inum%10)/10;
        o2num[0]=inum%10;
    }
    for(i=0;i<2;i++)
    {
        o2num[i]=value2char(o2num[i]);
    }
    return;
}

unsigned char value2char(unsigned char value)
{
    if(value==0)
    {
        return '0';
    }
    else if(value ==1)
    {
        return '1';
    }
    else if(value == 2)
    {
        return '2';
    }
    else if(value == 3)
    {
        return '3';
    }
    else if(value == 4)
    {
        return '4';
    }
    else if(value == 5)
    {
        return '5';
    }
    else if(value == 6)
    {
        return '6';
    }
    else if(value == 7)
    {
        return '7';
    }
    else if(value == 8)
    {
        return '8';
    }
    else if(value == 9)
    {
        return '9';
    }
}

void caculate()
{
    unsigned char eod=0,prt=0;
    if(microSecond>100)
    {
        Second++;
        microSecond = 0;
        sysclk=0;
        prt=1;

    }
    if(Second==60)
    {
        Minute++;
        Second =0;
        sysclk=0;

    }
    if(Minute==60)
    {
        Hour++;
        Minute = 0;
    }
    if(Hour==24)
    {
        Day++;
        Hour = 0;
        eod=1;
    }
    if(Month==1 || Month==3 || Month==5 || Month==7 || Month==8 || Month==10 || Month ==12)
    {
        if(Day==32)
        {
            Month++;
            Day = 1;
        }
    }
    else
    {
        if(Month == 2 && Year%4!=0)
        {
            if(Day==29)
            {
                Month++;
                Day = 1;
            }
            else if(Day == 30)
            {
                Month++;
                Day =1;
            }
        }
        else
        {
            if(Day==31)
            {
                Month++;
                Day = 1;
            }
        }
    }
    if(Month==13)
    {
        Year++;
        Month=1;
    }
    if(prt==1)
    {
       output_time();
    }
    if(eod==1)
    {
        output_day();
    }
}
