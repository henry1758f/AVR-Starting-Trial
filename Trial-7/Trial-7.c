/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Trial-7
Version : 0.1
Date    : 2015/5/13
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
#include <stdio.h>
#include <stdlib.h>

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
/*OTHER Definitions*/
#define LCDbackground PORTD.PORTD6
#define ADD 11
#define DEC 12
#define MUL 13
#define DIV 14
#define EQU 15

//Global variables define
unsigned char Keypad[16]={0xEE,0xED,0xEB,0xE7,
                          0xDE,0xDD,0xDB,0xD7,
                          0xBE,0xBD,0xBB,0xB7,
                          0x7E,0x7D,0x7B,0x77};
unsigned char fnc=0,num_pointer=0,
              dotA=0xFF, dotB=0xFF, dotC=0;  
double numA=0,numB=0,numC;
unsigned char pressed=0xFF;

                          
/*Function Declear*/
unsigned char input(unsigned char);
void caculate(unsigned char );
unsigned char printfnc(unsigned char);

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
fnc=0;
num_pointer=0;
dotA=0xFF;
dotB=0xFF; 
dotC=0;  
numA=0;
numB=0;
numC=0;
lcd_clear();


}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    unsigned char kbsw[4]={0xF7,0xFB,0xFD,0xFE};
    unsigned char i,j,error,none=0;    
    unsigned char num[5];
    for(i=0;i<4;i++)
    {             
        PORTA=kbsw[i];
        for(j=0;j<16;j++)
        {
            if(PINA==Keypad[j])
            {   
                if(pressed!=j)
                {
                    error = input(j);
                }
                else 
                {
                    return;
                } 
                pressed = j;
                TCNT0=0x00; 
                return;
            }  
        }
    }
    if(none==0)
    {
        pressed=0xFF;
    }
    
    
    TCNT0=0x00;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTA=0xF0;
DDRA=0x0F;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x0F;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=Out 
// State7=T State6=1 State5=0 State4=0 State3=T State2=T State1=T State0=1 
PORTD=0x41;
DDRD=0x71;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
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
// D4 - PORTB Bit 0
// D5 - PORTB Bit 1
// D6 - PORTB Bit 2
// D7 - PORTB Bit 3
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")
lcd_gotoxy(0,1);
lcd_putsf("= Verison 0.1 ="); 
lcd_gotoxy(2,0);
lcd_putsf("Calculactor");
delay_ms(1000);
lcd_clear();
TCCR0=FOSC1024;

while (1)
      {
            
            while(1);

      }
}


unsigned char input(unsigned char KEY)
{
    unsigned char num[32]; 
    unsigned char i=0;
    unsigned char dotA_trans,dotB_trans; 
    double KEY_dot=KEY;
    if(dotA==0xFF)
    {
        dotA_trans=0;
    }
    else
    {
        dotA_trans=dotA;
    } 
    if(dotB==0xFF)
    {
        dotB_trans=0;
    }
    else
    {
        dotB_trans=dotB;
    }
     
    if(num_pointer==0)              //numA Input
    {   
        /*numA Input*/
        if(KEY<10 && dotA==0xFF)
        {
            numA=numA*10+KEY;
            //sprintf(num,"%f",numA);
            ftoa(numA,dotA_trans,num); 
            lcd_gotoxy(0,0);
            lcd_puts(num);        
        }
        else if(KEY<10 && dotA!=0xFF)
        {
            for(i=0;i<dotA_trans;i++)
            {
                KEY_dot/=10;
            }
            numA=(numA+KEY_dot);
            //sprintf(num,"%f",numA);
            dotA++;
            ftoa(numA,dotA_trans,num); 
            lcd_gotoxy(0,0);
            lcd_puts(num);    
        } 
        else if(KEY==10 && dotA==0xFF)
        {
            ftoa(numA,dotA_trans,num);
            dotA=1; 
            lcd_gotoxy(0,0);
            lcd_puts(num); 
            lcd_putchar('.');       
        } 
        else if(KEY==ADD)
        {
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('+');
            fnc=ADD;
            num_pointer=1;    
        }
        else if(KEY==DEC)
        {
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('-');
            fnc=DEC;
            num_pointer=1;    
        }
        else if(KEY==MUL)
        {
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('*');
            fnc=MUL;
            num_pointer=1;    
        }
        else if(KEY==DIV)
        {
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('/');
            fnc=DIV; 
            num_pointer=1;   
        } 
        else if(KEY==EQU)
        {
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('='); 
            num_pointer=2; 
            numC=numA;
            ftoa(numC,dotA_trans,num); 
            lcd_gotoxy(0,1);
            lcd_puts(num);
            fnc=EQU;   
        }
        
    }
    else if(num_pointer==1)             //numB Input
    {   
        /*numB Input*/
        if(KEY<10 && dotB==0xFF)
        {
            numB=numB*10+KEY;
            //sprintf(num,"%f",numA);
            ftoa(numB,dotB_trans,num); 
            lcd_gotoxy(0,1);
            lcd_puts(num);        
        }
        else if(KEY<10 && dotB!=0xFF)
        {
            for(i=0;i<dotB_trans;i++)
            {
                KEY_dot/=10;
            }
            numB=(numB+KEY_dot);
            //sprintf(num,"%f",numA);
            dotB++;
            ftoa(numB,dotB_trans,num); 
            lcd_gotoxy(0,1);
            lcd_puts(num);    
        } 
        else if(KEY==10 && dotB==0xFF)
        {
            ftoa(numB,dotB_trans,num);
            dotB=1; 
            lcd_gotoxy(0,1);
            lcd_puts(num); 
            lcd_putchar('.');       
        }  
        else if(KEY==ADD)
        {   
            caculate(fnc);
            lcd_clear();
            lcd_gotoxy(0,0);
            ftoa(numC,dotC,num);
            lcd_puts(num);
            numB=0;dotB=0;numA=numC;
            
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('+');
            num_pointer=1;
            fnc=ADD;    
        }
        else if(KEY==DEC)
        {   
            caculate(fnc);
            lcd_clear();
            lcd_gotoxy(0,0);
            ftoa(numC,dotC,num);
            lcd_puts(num);
            numB=0;dotB=0;numA=numC;
        
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('-');
            num_pointer=1;
            fnc=DEC;    
        }
        else if(KEY==MUL)
        {   
            caculate(fnc);
            lcd_clear();
            lcd_gotoxy(0,0);
            ftoa(numC,dotC,num);
            lcd_puts(num);
            numB=0;dotB=0;numA=numC;
        
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('*');
            num_pointer=1;
            fnc=MUL;    
        }
        else if(KEY==DIV)
        {   
            caculate(fnc);
            lcd_clear();
            lcd_gotoxy(0,0);
            ftoa(numC,dotC,num);
            lcd_puts(num);
            numB=0;dotB=0;numA=numC;
            
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('/'); 
            num_pointer=1;
            fnc=DIV;   
        } 
        else if(KEY==EQU)
        {   
            if(dotA_trans!=0)
            {
                dotA_trans--;
            }
            if(dotB_trans!=0)
            {
                dotB_trans--;
            }
            lcd_clear();  
            ftoa(numA,dotA_trans,num); 
            lcd_gotoxy(0,0);
            lcd_puts(num);
            lcd_putchar(printfnc(fnc));
            ftoa(numB,dotB_trans,num); 
            lcd_puts(num);
               
            
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('='); 
            num_pointer=2; 
            caculate(fnc);
            ftoa(numC,dotC,num); 
            lcd_gotoxy(0,1);
            lcd_puts(num);
        }
    } 
    
    else if(num_pointer==2)              //numC Result
    {   
        /*numC Result*/
        if(KEY<10)
        {
            fnc=0;
            num_pointer=0;
            dotA=0xFF;
            dotB=0xFF; 
            dotC=0; 
            dotA_trans=0;
            dotB_trans=0; 
            numA=0;
            numB=0;
            numC=0;
            lcd_clear();
            
            numA=numA*10+KEY;
            ftoa(numA,dotA_trans,num); 
            lcd_gotoxy(0,0);
            lcd_puts(num);        
        }
        else if(KEY==10)
        {   
            numA=numC;
            fnc=0;
            num_pointer=0;
            dotA=1;
            dotB=0xFF; 
            dotC=0; 
            dotA_trans=0;
            dotB_trans=0; 
            numB=0;
            numC=0;
            lcd_clear();

            
            
            ftoa(numA,dotA_trans,num);
            dotA=1; 
            lcd_gotoxy(0,0);
            lcd_puts(num); 
            lcd_putchar('.');       
        } 
        else if(KEY==ADD)
        {   
            numA=numC;
            fnc=ADD;
            num_pointer=1;
            dotA=dotC;
            dotB=0xFF; 
            dotA_trans=dotC;
            dotC=0;
            dotB_trans=0; 
            numB=0;
            numC=0;
            lcd_clear();
            
            
            ftoa(numA,dotA,num);
            dotA=1; 
            lcd_gotoxy(0,0);
            lcd_puts(num); 
        
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('+');
            fnc=ADD;
            num_pointer=1;    
        }
        else if(KEY==DEC)
        {  
            numA=numC;
            fnc=DEC;
            num_pointer=1;
            dotA=dotC;
            dotB=0xFF; 
            dotA_trans=dotC; 
            dotC=0;
            dotB_trans=0; 
            numB=0;
            numC=0;
            lcd_clear();
            
            
            ftoa(numA,dotA_trans,num);
            dotA=1; 
            lcd_gotoxy(0,0);
            lcd_puts(num);
            
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('-');
            fnc=DEC;
            num_pointer=1;    
        }
        else if(KEY==MUL)
        {   
            numA=numC;
            fnc=MUL;
            num_pointer=1;
            dotA=dotC;
            dotB=0xFF; 
            dotA_trans=dotC; 
            dotC=0;
            dotB_trans=0; 
            numB=0;
            numC=0;
            lcd_clear();
            
            
            ftoa(numA,dotA_trans,num);
            dotA=1; 
            lcd_gotoxy(0,0);
            lcd_puts(num);
        
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('*');
            fnc=MUL;
            num_pointer=1;    
        }
        else if(KEY==DIV)
        {   
            numA=numC;
            fnc=DIV;
            num_pointer=1;
            dotA=dotC;
            dotB=0xFF; 
            dotA_trans=dotC;
            dotC=0;
            dotB_trans=0; 
            numB=0;
            numC=0;
            lcd_clear();
            
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('/');
            fnc=DIV; 
            num_pointer=1;   
        } 
        else if(KEY==EQU)
        {   /*
            lcd_gotoxy(15,0);
            //lcd_puts(num); 
            lcd_putchar('='); 
            num_pointer=2; 
            numA=numC;
            ftoa(numC,dotC,num); 
            lcd_gotoxy(0,1);
            lcd_puts(num);
            fnc=EQU;*/   
        }
        
    }
    
}

void caculate(unsigned char f)
{
    if(f==ADD)
    {   
        if(dotA!=0xFF)
        {
            dotC=dotA-1;
        }
        if(dotB!=0xFF)
        {
            if(dotA==255 || dotB>dotA)
            {
                dotC=dotB-1;
            }
                
        }
        numC=numA+numB;
        return;    
    }
    else if(f==DEC)
    {   
       if(dotA!=0xFF)
        {
            dotC=dotA-1;
        }
        if(dotB!=0xFF)
        {
            if(dotA==255 || dotB>dotA)
            {
                dotC=dotB-1;
            }       
        }
        numC=numA-numB; 
        return;   
    }
    else if(f==MUL)
    {
        if(dotA!=0xFF)
        {
            dotC=dotA-1;
        }
        if(dotB!=0xFF)
        {
            dotC+=dotB-1;    
        }
        numC=numA*numB;
        return;    
    }
    else if(f==DIV)
    {   
        dotC=6;
        numC=numA/numB;
        return;    
    }
    else if(f==EQU)
    {
        numC=numA;
        dotC=dotA;
        return;    
    }
}

unsigned char printfnc(unsigned char f)
{
    if(f==ADD)
    {   
        return '+';    
    }
    else if(f==DEC)
    { 
        return '-';   
    }
    else if(f==MUL)
    {
        return '*';    
    }
    else if(f==DIV)
    {
        return '/';    
    }
    else if(f==EQU)
    {
        return '=';    
    }
    
}