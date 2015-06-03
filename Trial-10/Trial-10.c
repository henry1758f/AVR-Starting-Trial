/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2015/6/2
Author  : PerTic@n
Company : If You Like This Software,Buy It
Comments: 


Chip type               : AT90S8535
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <90s8535.h>
#include <stdio.h>
#include <stdlib.h>

// Alphanumeric LCD functions
#include <alcd.h>
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
unsigned char Keypad[16]={0xEE,0xED,0xEB,0xE7,
                          0xDE,0xDD,0xDB,0xD7,
                          0xBE,0xBD,0xBB,0xB7,
                          0x7E,0x7D,0x7B,0x77};
unsigned char pressed,numb;
void output();
void pop(unsigned char);
eeprom unsigned int num;


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
                /*if((num&0x000F)!=j)
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
                } */
                if(j==0)
                {
                    num=0;
                    output();
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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
// State7=T State6=1 State5=T State4=T State3=T State2=T State1=0 State0=0 
PORTD=0x41;
DDRD=0x71;

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

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 5
// RD - PORTD Bit 4
// EN - PORTD Bit 0
// D4 - PORTB Bit 0
// D5 - PORTB Bit 1
// D6 - PORTB Bit 2
// D7 - PORTB Bit 3
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")
//lcd_clear();
lcd_gotoxy(2,0);
lcd_putsf("= Trial-10 ="); 
lcd_gotoxy(2,1);
lcd_putsf("LCD Enable");
delay_ms(1000);
lcd_clear();

delay_ms(1000);
TCCR0=FOSC1024; 
output();
while (1)
      {
            if(PIND.2==0)
            {
                num++;
                output();
                while(PIND.2==0);
            }
      }
      
}

void pop(unsigned char keyin)
{
        num=keyin;
        output();
        return;
}

void output()
{
    unsigned char a[6];
    lcd_clear();
    itoa(num,a); 
    lcd_gotoxy(0,0);
    lcd_puts(a);
}