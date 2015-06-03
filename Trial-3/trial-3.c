/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Practice_03
Version : 1.0.001
Date    : 2015/4/28
Author  : henry1758f@gmail.com
Company : KUAS EE501
Comments: Practice_03


Chip type               : AT90S8535
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <90s8535.h>
#include <delay.h>
/*TIMER SETTING CONFIG DEFINE*/
#define STOP 0x00
#define FOSC1 0x01
#define FOSC8 0x02
#define FOSC64 0x03
#define FOSC256 0x04
#define FOSC1024 0x05
/*TIMER0 SET*/
#define T0SET FOSC64

unsigned char eLED[5]={0b00001111,0b00001110,0b00001101,0b00001011,0b00000111};
unsigned char LED[10]={0b01111110,0b00001100,0b10110110,0b10011110,0b11001100,0b11011010,0b11111010,0b00001110,0b11111110,0b11011110};
unsigned int num=0,OVF_counter=0;

void output(unsigned char[4]);
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    unsigned int button;
    for(button=0;button<5000;button++)
    {
        if(PORTD.PORTD2==0)
        {
        }
        else
        {
            return;
        }
    }
    if(num==9999)
    {
        num = 0;
        TCCR0=STOP;

    }
    else
    {
        if(TCCR0!=STOP)
        {
            TCCR0=STOP;
        }
        else
        {
            TCCR0=T0SET;
        }
    }


}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    if(num==9999)
    {
        OVF_counter=0;
        TCCR0=0x00;
    }
    else if(num<9999/* && OVF_counter>1000*/)
    {
        num++;
        OVF_counter=0;
    }
    OVF_counter++;
}

// Declare your global variables here

void decoder(unsigned int inum)
{
    unsigned char onum[4];
    if(inum<10)
    {
        onum[0]=inum;
        onum[1]=0x00;
        onum[2]=0x00;
        onum[3]=0x00;
    }
    else if(inum<100 && inum>=10)
    {
        onum[0]=inum%10;
        inum=(inum-inum%10)/10;
        onum[1]=inum%10;
        onum[2]=0x00;
        onum[3]=0x00;
    }
    else if(inum<1000 && inum>=100)
    {
        onum[0]=inum%10;
        inum=(inum-inum%10)/10;
        onum[1]=inum%10;
        inum=(inum-inum%10)/10;
        onum[2]=inum%10;
        onum[3]=0x00;
    }
    else if(inum<10000 && inum>=1000)
    {
        onum[0]=inum%10;
        inum=(inum-inum%10)/10;
        onum[1]=inum%10;
        inum=(inum-inum%10)/10;
        onum[2]=inum%10;
        inum=(inum-inum%10)/10;
        onum[3]=inum%10;
    }
    output(onum);
}

void output(unsigned char in[4])
{
    unsigned char i;
    for(i=1;i<5;i++)
    {
        PORTC = eLED[i];//eLED[i];
        PORTB = LED[in[i-1]];//LED[in[i-1]];
        delay_us(800);
    }
}




void main(void)
{
// Declare your local variables here
    int i;
// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=1 State2=1 State1=1 State0=1
PORTC=0x0F;
DDRC=0xFF;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
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
// INT0 Mode: Falling Edge
// INT1: Off
GIMSK=0x40;
MCUCR=0x02;
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

// Global enable interrupts
#asm("sei")
    TCCR0=T0SET;
    while (1)
    {        PORTC.PORTC6=1;
        decoder(num);
    }
}
