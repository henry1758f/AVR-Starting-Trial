
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : AT90S8535
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Smart register allocation          : Off
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME AT90S8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 607
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _num=R4
	.DEF _go=R6
	.DEF _pressed=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0xF,0xE,0xD,0xB,0x7
_0x4:
	.DB  0x7E,0xC,0xB6,0x9E,0xCC,0xDA,0xFA,0xE
	.DB  0xFE,0xDE,0xEE,0xF8,0x72,0xBC,0xF2,0xE2
_0x5:
	.DB  0xEE,0xED,0xEB,0xE7,0xDE,0xDD,0xDB,0xD7
	.DB  0xBE,0xBD,0xBB,0xB7,0x7E,0x7D,0x7B,0x77
_0x2B:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x05
	.DW  _eLED
	.DW  _0x3*2

	.DW  0x10
	.DW  _LED
	.DW  _0x4*2

	.DW  0x10
	.DW  _Keypad
	.DW  _0x5*2

	.DW  0x04
	.DW  0x04
	.DW  _0x2B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM
	ADIW R30,1
	MOV  R24,R0
	LPM
	ADIW R30,1
	MOV  R25,R0
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM
	ADIW R30,1
	MOV  R26,R0
	LPM
	ADIW R30,1
	MOV  R27,R0
	LPM
	ADIW R30,1
	MOV  R1,R0
	LPM
	ADIW R30,1
	MOV  R22,R30
	MOV  R23,R31
	MOV  R31,R0
	MOV  R30,R1
__GLOBAL_INI_LOOP:
	LPM
	ADIW R30,1
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOV  R30,R22
	MOV  R31,R23
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2015/4/30
;Author  : PerTic@n
;Company : If You Like This Software,Buy It
;Comments:
;
;
;Chip type               : AT90S8535
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <90s8535.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0x30
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define true 1
;#define false 0
;/*TIMER SETTING CONFIG DEFINE*/
;#define STOP 0x00
;#define FOSC1 0x01
;#define FOSC8 0x02
;#define FOSC64 0x03
;#define FOSC256 0x04
;#define FOSC1024 0x05
;/*TIMER0 SET*/
;#define T0SET FOSC1024
;
;/*DATA*/
;unsigned char eLED[5]={0b00001111,0b00001110,0b00001101,0b00001011,0b00000111};

	.DSEG
;unsigned char LED[16]={0b01111110,0b00001100,0b10110110,0b10011110,
;                       0b11001100,0b11011010,0b11111010,0b00001110,
;                       0b11111110,0b11011110,0b11101110,0b11111000,
;                       0b01110010,0b10111100,0b11110010,0b11100010};
;unsigned char Keypad[16]={0xEE,0xED,0xEB,0xE7,
;                          0xDE,0xDD,0xDB,0xD7,
;                          0xBE,0xBD,0xBB,0xB7,
;                          0x7E,0x7D,0x7B,0x77};
;unsigned int num=0x0000,go=0;
;unsigned char pressed;
;/**/
;void output(unsigned char[]);
;void pop(unsigned char);
;void decoder(unsigned int);
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0038 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0039     unsigned char i,j,k=0;
; 0000 003A     unsigned char kbsw[4]={0xF7,0xFB,0xFD,0xFE};
; 0000 003B     for(i=0;i<=3;i++)
	SBIW R28,4
	LDI  R30,LOW(247)
	ST   Y,R30
	LDI  R30,LOW(251)
	STD  Y+1,R30
	LDI  R30,LOW(253)
	STD  Y+2,R30
	LDI  R30,LOW(254)
	STD  Y+3,R30
	RCALL __SAVELOCR3
;	i -> R16
;	j -> R17
;	k -> R18
;	kbsw -> Y+3
	LDI  R18,0
	LDI  R16,LOW(0)
_0x7:
	CPI  R16,4
	BRSH _0x8
; 0000 003C     {
; 0000 003D         PORTA=kbsw[i];
	RCALL SUBOPT_0x0
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,3
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x1B,R30
; 0000 003E         /*if(PINA==kbsw[i])
; 0000 003F         {
; 0000 0040             pressed == true;
; 0000 0041         } */
; 0000 0042         for(j=0;j<16;j++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,16
	BRSH _0xB
; 0000 0043         {
; 0000 0044             if(PINA==Keypad[j])
	IN   R30,0x19
	MOV  R26,R30
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_Keypad)
	SBCI R31,HIGH(-_Keypad)
	LD   R30,Z
	CP   R30,R26
	BRNE _0xC
; 0000 0045             {
; 0000 0046                 if((num&0x000F)!=j)
	RCALL SUBOPT_0x2
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xD
; 0000 0047                 {
; 0000 0048                     pop(j);
	RCALL SUBOPT_0x3
; 0000 0049                     pressed=j;
; 0000 004A                     k=1;
; 0000 004B                     //delay_ms(10);
; 0000 004C                     return;
	RJMP _0x2A
; 0000 004D                 }
; 0000 004E                 else if((num&0x000F)==j && (pressed == 0xFF))
_0xD:
	RCALL SUBOPT_0x2
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x10
	LDI  R30,LOW(255)
	CP   R30,R8
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 004F                 {
; 0000 0050                     pop(j);
	RCALL SUBOPT_0x3
; 0000 0051                     pressed=j;
; 0000 0052                     k=1;
; 0000 0053                     return;
	RJMP _0x2A
; 0000 0054                     delay_ms(10);
; 0000 0055                 }
; 0000 0056                 else
_0xF:
; 0000 0057                 {
; 0000 0058                     k=1;
	LDI  R18,LOW(1)
; 0000 0059                 }
; 0000 005A             }
; 0000 005B         }
_0xC:
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 005C     }
	SUBI R16,-1
	RJMP _0x7
_0x8:
; 0000 005D     if(k==0)
	CPI  R18,0
	BRNE _0x13
; 0000 005E     {
; 0000 005F         pressed=0xFF;
	LDI  R30,LOW(255)
	MOV  R8,R30
; 0000 0060     }
; 0000 0061     else
_0x13:
; 0000 0062     {
; 0000 0063         return;
; 0000 0064     }
; 0000 0065 }
_0x2A:
	RCALL __LOADLOCR3
	ADIW R28,7
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;/*7LED*/
;void decoder(unsigned int inum)
; 0000 006A {
_decoder:
; 0000 006B     unsigned char onum[4];
; 0000 006C     if(inum<0x0010)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
;	inum -> Y+4
;	onum -> Y+0
	RCALL SUBOPT_0x4
	SBIW R26,16
	BRSH _0x15
; 0000 006D     {
; 0000 006E         onum[0]=(unsigned char)inum;
	LDD  R30,Y+4
	ST   Y,R30
; 0000 006F         onum[1]=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x5
; 0000 0070         onum[2]=0x00;
; 0000 0071         onum[3]=0x00;
	RJMP _0x29
; 0000 0072     }
; 0000 0073     else if(inum<0x0100 && inum>=0x0010)
_0x15:
	RCALL SUBOPT_0x6
	BRSH _0x18
	RCALL SUBOPT_0x4
	SBIW R26,16
	BRSH _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 0074     {
; 0000 0075         onum[0]=(unsigned char)inum%0x0010;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0076         inum=(inum-inum%0x0010)/0x0010;
; 0000 0077         onum[1]=(unsigned char)inum%0x0010;
	RCALL SUBOPT_0x5
; 0000 0078         onum[2]=0x00;
; 0000 0079         onum[3]=0x00;
	RJMP _0x29
; 0000 007A     }
; 0000 007B     else if(inum<0x1000 && inum>=0x0100)
_0x17:
	RCALL SUBOPT_0x9
	BRSH _0x1C
	RCALL SUBOPT_0x6
	BRSH _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 007C     {
; 0000 007D         onum[0]=(unsigned char)inum%0x0010;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 007E         inum=(inum-inum%0x0010)/0x0010;
; 0000 007F         onum[1]=(unsigned char)inum%0x0010;
	STD  Y+1,R30
; 0000 0080         inum=(inum-inum%0x0010)/0x0010;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0xA
; 0000 0081         onum[2]=(unsigned char)inum%0x0010;
	STD  Y+2,R30
; 0000 0082         onum[3]=0x00;
	LDI  R30,LOW(0)
	RJMP _0x29
; 0000 0083     }
; 0000 0084     else if(inum<=0xFFFF && inum>=0x1000)
_0x1B:
	RCALL SUBOPT_0x4
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x20
	RCALL SUBOPT_0x9
	BRSH _0x21
_0x20:
	RJMP _0x1F
_0x21:
; 0000 0085     {
; 0000 0086         onum[0]=(unsigned char)inum%0x0010;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 0087         inum=(inum-inum%0x0010)/0x0010;
; 0000 0088         onum[1]=(unsigned char)inum%0x0010;
	STD  Y+1,R30
; 0000 0089         inum=(inum)/0x0010;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL __LSRW4
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 008A         onum[2]=(unsigned char)inum%0x0010;
	RCALL SUBOPT_0x7
	STD  Y+2,R30
; 0000 008B         inum=(inum-inum%0x0010)/0x0010;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0xA
; 0000 008C         onum[3]=(unsigned char)inum%0x0010;
_0x29:
	STD  Y+3,R30
; 0000 008D     }
; 0000 008E     output(onum);
_0x1F:
	MOV  R26,R28
	MOV  R27,R29
	RCALL _output
; 0000 008F }
	ADIW R28,6
	RET
;
;void output(unsigned char in[4])
; 0000 0092 {
_output:
; 0000 0093     unsigned char i;
; 0000 0094     for(i=1;i<5;i++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R16
;	in -> Y+1
;	i -> R16
	LDI  R16,LOW(1)
_0x23:
	CPI  R16,5
	BRSH _0x24
; 0000 0095     {
; 0000 0096         PORTC = eLED[i];//eLED[i];
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_eLED)
	SBCI R31,HIGH(-_eLED)
	LD   R30,Z
	OUT  0x15,R30
; 0000 0097         PORTB = LED[in[i-1]];//LED[in[i-1]];
	RCALL SUBOPT_0x0
	SBIW R30,1
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R31,0
	SUBI R30,LOW(-_LED)
	SBCI R31,HIGH(-_LED)
	LD   R30,Z
	OUT  0x18,R30
; 0000 0098         delay_us(800);
	__DELAY_USW 1600
; 0000 0099     }
	SUBI R16,-1
	RJMP _0x23
_0x24:
; 0000 009A }
	LDD  R16,Y+0
	ADIW R28,3
	RET
;
;/**/
;
;// Declare your global variables here
;
;void main(void)
; 0000 00A1 {
_main:
; 0000 00A2 // Declare your local variables here
; 0000 00A3 
; 0000 00A4 
; 0000 00A5 // Input/Output Ports initialization
; 0000 00A6 // Port A initialization
; 0000 00A7 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00A8 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 00A9 PORTA=0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 00AA DDRA=0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 00AB 
; 0000 00AC // Port B initialization
; 0000 00AD // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00AE // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00AF PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00B0 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 00B1 
; 0000 00B2 // Port C initialization
; 0000 00B3 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00B4 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 00B5 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00B6 DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 00B7 
; 0000 00B8 // Port D initialization
; 0000 00B9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00BB PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00BC DDRD=0x00;
	OUT  0x11,R30
; 0000 00BD 
; 0000 00BE // Timer/Counter 0 initialization
; 0000 00BF // Clock source: System Clock
; 0000 00C0 // Clock value: Timer 0 Stopped
; 0000 00C1 TCCR0=0x00;
	OUT  0x33,R30
; 0000 00C2 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00C3 
; 0000 00C4 // Timer/Counter 1 initialization
; 0000 00C5 // Clock source: System Clock
; 0000 00C6 // Clock value: Timer1 Stopped
; 0000 00C7 // Mode: Normal top=0xFFFF
; 0000 00C8 // OC1A output: Discon.
; 0000 00C9 // OC1B output: Discon.
; 0000 00CA // Noise Canceler: Off
; 0000 00CB // Input Capture on Falling Edge
; 0000 00CC // Timer1 Overflow Interrupt: Off
; 0000 00CD // Input Capture Interrupt: Off
; 0000 00CE // Compare A Match Interrupt: Off
; 0000 00CF // Compare B Match Interrupt: Off
; 0000 00D0 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00D1 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00D2 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00D3 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00D4 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D5 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D6 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D7 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D8 
; 0000 00D9 // Timer/Counter 2 initialization
; 0000 00DA // Clock source: System Clock
; 0000 00DB // Clock value: Timer2 Stopped
; 0000 00DC // Mode: Normal top=0xFF
; 0000 00DD // OC2 output: Disconnected
; 0000 00DE ASSR=0x00;
	OUT  0x22,R30
; 0000 00DF TCCR2=0x00;
	OUT  0x25,R30
; 0000 00E0 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00E1 OCR2=0x00;
	OUT  0x23,R30
; 0000 00E2 
; 0000 00E3 // External Interrupt(s) initialization
; 0000 00E4 // INT0: Off
; 0000 00E5 // INT1: Off
; 0000 00E6 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 00E7 MCUCR=0x00;
	OUT  0x35,R30
; 0000 00E8 
; 0000 00E9 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00EA TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00EB 
; 0000 00EC // UART initialization
; 0000 00ED // UART disabled
; 0000 00EE UCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00EF 
; 0000 00F0 // Analog Comparator initialization
; 0000 00F1 // Analog Comparator: Off
; 0000 00F2 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00F3 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F4 
; 0000 00F5 // ADC initialization
; 0000 00F6 // ADC disabled
; 0000 00F7 ADCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 00F8 
; 0000 00F9 // SPI initialization
; 0000 00FA // SPI disabled
; 0000 00FB SPCR=0x00;
	OUT  0xD,R30
; 0000 00FC 
; 0000 00FD // Global enable interrupts
; 0000 00FE #asm("sei")
	sei
; 0000 00FF 
; 0000 0100 TCCR0=T0SET;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0101 while (1)
_0x25:
; 0000 0102       {
; 0000 0103       /*
; 0000 0104             for(i=0;i<4;i++)
; 0000 0105             {
; 0000 0106                 PORTA=PORTA|kbsw[i];
; 0000 0107                 for(j=0;j<16;j++)
; 0000 0108                 {
; 0000 0109                     if(PORTA==Keypad[j])
; 0000 010A                     {
; 0000 010B                         pop(j);
; 0000 010C                     }
; 0000 010D                 }
; 0000 010E             }
; 0000 010F                          */
; 0000 0110             decoder(num);
	__GETW2R 4,5
	RCALL _decoder
; 0000 0111             //decoder(pressed);
; 0000 0112       }
	RJMP _0x25
; 0000 0113 }
_0x28:
	RJMP _0x28
;
;void pop(unsigned char keyin)
; 0000 0116 {
_pop:
; 0000 0117         num=num<<4;
	ST   -Y,R26
;	keyin -> Y+0
	__GETW1R 4,5
	RCALL __LSLW4
	__PUTW1R 4,5
; 0000 0118         num+=keyin;
	LD   R30,Y
	LDI  R31,0
	__ADDWRR 4,5,30,31
; 0000 0119         return;
	ADIW R28,1
	RET
; 0000 011A }

	.DSEG
_eLED:
	.BYTE 0x5
_LED:
	.BYTE 0x10
_Keypad:
	.BYTE 0x10

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	__GETW1R 4,5
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOV  R26,R30
	MOV  R27,R31
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOV  R26,R17
	RCALL _pop
	MOV  R8,R17
	LDI  R18,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STD  Y+1,R30
	LDI  R30,LOW(0)
	STD  Y+2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDD  R30,Y+4
	ANDI R30,LOW(0xF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x8:
	ST   Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	RCALL SUBOPT_0x4
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R26
	MOV  R31,R27
	RCALL __LSRW4
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	RCALL SUBOPT_0x4
	CPI  R26,LOW(0x1000)
	LDI  R30,HIGH(0x1000)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xA:
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	RCALL SUBOPT_0x4
	SUB  R26,R30
	SBC  R27,R31
	MOV  R30,R26
	MOV  R31,R27
	RCALL __LSRW4
	STD  Y+4,R30
	STD  Y+4+1,R31
	RJMP SUBOPT_0x7


	.CSEG
__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
