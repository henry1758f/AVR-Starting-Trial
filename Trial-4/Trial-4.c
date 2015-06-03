/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 2015/4/30
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
#include <delay.h>

#define true 1
#define false 0
/*TIMER SETTING CONFIG DEFINE*/
#define STOP 0x00
#define FOSC1 0x01
#define FOSC8 0x02
#define FOSC64 0x03
#define FOSC256 0x04
#define FOSC1024 0x05
/*TIMER0 SET*/
#define T0SET FOSC1024

/*DATA*/
unsigned char eLED[5]={0b00001111,0b00001110,0b00001101,0b00001011,0b00000111};
unsigned char LED[16]={0b01111110,0b00001100,0b10110110,0b10011110,
                       0b11001100,0b11011010,0b11111010,0b00001110,
                       0b11111110,0b11011110,0b11101110,0b11111000,
                       0b01110010,0b10111100,0b11110010,0b11100010};
unsigned char Keypad[16]={0xEE,0xED,0xEB,0xE7,
                          0xDE,0xDD,0xDB,0xD7,
                          0xBE,0xBD,0xBB,0xB7,
                          0x7E,0x7D,0x7B,0x77};
unsigned int num=0x0000,go=0;
unsigned char pressed;
/**/
void output(unsigned char[]);
void pop(unsigned char);
void decoder(unsigned int);
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    unsigned char i,j,k=0;
    unsigned char kbsw[4]={0xF7,0xFB,0xFD,0xFE};
    for(i=0;i<=3;i++)
    {
        PORTA=kbsw[i];
        /*if(PINA==kbsw[i])
        {
            pressed == true;
        } */
        for(j=0;j<16;j++)
        {
            if(PINA==Keypad[j])
            {
                if((num&0x000F)!=j)
                {
                    pop(j);
                    pressed=j;
                    k=1;
                    //delay_ms(10);
                    return;
                }
                else if((num&0x000F)==j && (pressed == 0xFF))
                {
                    pop(j);
                    pressed=j;
                    k=1;
                    return;
                    delay_ms(10);
                }
                else
                {
                    k=1;
                }
            }
        }
    }
    if(k==0)
    {
        pressed=0xFF;
    }
    else
    {
        return;
    }
}


/*7LED*/
void decoder(unsigned int inum)
{
    unsigned char onum[4];
    if(inum<0x0010)
    {
        onum[0]=(unsigned char)inum;
        onum[1]=0x00;
        onum[2]=0x00;
        onum[3]=0x00;
    }
    else if(inum<0x0100 && inum>=0x0010)
    {
        onum[0]=(unsigned char)inum%0x0010;
        inum=(inum-inum%0x0010)/0x0010;
        onum[1]=(unsigned char)inum%0x0010;
        onum[2]=0x00;
        onum[3]=0x00;
    }
    else if(inum<0x1000 && inum>=0x0100)
    {
        onum[0]=(unsigned char)inum%0x0010;
        inum=(inum-inum%0x0010)/0x0010;
        onum[1]=(unsigned char)inum%0x0010;
        inum=(inum-inum%0x0010)/0x0010;
        onum[2]=(unsigned char)inum%0x0010;
        onum[3]=0x00;
    }
    else if(inum<=0xFFFF && inum>=0x1000)
    {
        onum[0]=(unsigned char)inum%0x0010;
        inum=(inum-inum%0x0010)/0x0010;
        onum[1]=(unsigned char)inum%0x0010;
        inum=(inum)/0x0010;
        onum[2]=(unsigned char)inum%0x0010;
        inum=(inum-inum%0x0010)/0x0010;
        onum[3]=(unsigned char)inum%0x0010;
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

/**/

// Declare your global variables here

void main(void)
{
// Declare your local variables here


// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
PORTA=0xF0;
DDRA=0x0F;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
PORTC=0x00;
DDRC=0x0F;

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
// INT0: Off
// INT1: Off
GIMSK=0x00;
MCUCR=0x00;

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
      {
      /*
            for(i=0;i<4;i++)
            {
                PORTA=PORTA|kbsw[i];
                for(j=0;j<16;j++)
                {
                    if(PORTA==Keypad[j])
                    {
                        pop(j);
                    }
                }
            }
                         */
            decoder(num);
            //decoder(pressed);
      }
}

void pop(unsigned char keyin)
{
        num=num<<4;
        num+=keyin;
        return;
}
