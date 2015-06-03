
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
	.DEF _Year=R4
	.DEF _microSecond=R6
	.DEF _sysclk=R8
	.DEF _Month=R10
	.DEF _Day=R11
	.DEF _Hour=R12
	.DEF _Minute=R13
	.DEF _Second=R14

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
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
	.DB  0x0,0x0,0x2,0x0,0x7,0x0,0xA,0x0
	.DB  0x0,0x1,0x2,0x1,0x5,0x1,0x8,0x1
	.DB  0xB,0x1
_0x4B:
	.DB  0xDF,0x7,0x0,0x0,0x0,0x0,0xC,0x1F
	.DB  0x17,0x3B,0x37
_0x0:
	.DB  0x54,0x68,0x69,0x73,0x20,0x69,0x73,0x20
	.DB  0x61,0x20,0x63,0x6C,0x6F,0x63,0x6B,0x21
	.DB  0x0,0x56,0x65,0x72,0x69,0x73,0x6F,0x6E
	.DB  0x20,0x30,0x2E,0x31,0x0,0x41,0x44,0x31
	.DB  0x39,0x39,0x39,0x2F,0x31,0x32,0x2F,0x33
	.DB  0x31,0x0,0x30,0x30,0x3A,0x30,0x30,0x27
	.DB  0x30,0x30,0x22,0x30,0x30,0x30,0x30,0x0
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x41,0x44,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  0x04
	.DW  _0x4B*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;    /*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2015/5/1
;Author  :
;Company :
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
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#include <delay.h>
;/*TIMER SETTING CONFIG DEFINE*/
;#define STOP 0x00
;#define FOSC1 0x01
;#define FOSC8 0x02
;#define FOSC64 0x03
;#define FOSC256 0x04
;#define FOSC1024 0x05
;/*TIMER0 SET*/
;#define T0SET FOSC8
;
;
;int Year=2015,microSecond=0,sysclk=0;
;unsigned char Month=12,Day=31,Hour=23,Minute=59,Second=55;
;unsigned char lcd_loc[9][2]={{0,0},{2,0},{7,0},{10,0},{0,1},{2,1},{5,1},{8,1},{11,1}};

	.DSEG
;unsigned char onum[4],o2num[2];
;
;void output_time();
;void output_day();
;void decoder(unsigned int inum);
;void d2ecoder(unsigned int);
;unsigned char value2char(unsigned char);
;void caculate();
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0035 {

	.CSEG
_ext_int0_isr:
; 0000 0036 // Place your code here
; 0000 0037 
; 0000 0038 }
	RETI
;
;// Timer 0 overflow interrupt service routine
;#define ADDIV 38
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 003D {
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 003E     sysclk++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 8,9,30,31
; 0000 003F     microSecond=sysclk/ADDIV;
	RCALL SUBOPT_0x0
	RCALL __DIVW21
	__PUTW1R 6,7
; 0000 0040     //Second=sysclk/ADDIV;
; 0000 0041     //Second++;
; 0000 0042     if(sysclk%ADDIV==0)
	RCALL SUBOPT_0x0
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x4
; 0000 0043     {
; 0000 0044         PORTA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 0045         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0046 
; 0000 0047     }
; 0000 0048     TCNT0=0x44;
_0x4:
	LDI  R30,LOW(68)
	OUT  0x32,R30
; 0000 0049     //caculate();
; 0000 004A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0050 {
_main:
; 0000 0051 // Declare your local variables here
; 0000 0052 
; 0000 0053 
; 0000 0054 // Input/Output Ports initialization
; 0000 0055 // Port A initialization
; 0000 0056 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0057 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0058 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0059 DDRA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 005A 
; 0000 005B // Port B initialization
; 0000 005C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 005D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 005E PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005F DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0060 
; 0000 0061 // Port C initialization
; 0000 0062 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0063 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0064 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0065 DDRC=0x00;
	OUT  0x14,R30
; 0000 0066 
; 0000 0067 // Port D initialization
; 0000 0068 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0069 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006A PORTD=0x40;
	LDI  R30,LOW(64)
	OUT  0x12,R30
; 0000 006B DDRD=0x40;
	OUT  0x11,R30
; 0000 006C 
; 0000 006D // Timer/Counter 0 initialization
; 0000 006E // Clock source: System Clock
; 0000 006F // Clock value: 1000.000 kHz
; 0000 0070 TCCR0=STOP;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0071 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0072 
; 0000 0073 // Timer/Counter 1 initialization
; 0000 0074 // Clock source: System Clock
; 0000 0075 // Clock value: Timer1 Stopped
; 0000 0076 // Mode: Normal top=0xFFFF
; 0000 0077 // OC1A output: Discon.
; 0000 0078 // OC1B output: Discon.
; 0000 0079 // Noise Canceler: Off
; 0000 007A // Input Capture on Falling Edge
; 0000 007B // Timer1 Overflow Interrupt: Off
; 0000 007C // Input Capture Interrupt: Off
; 0000 007D // Compare A Match Interrupt: Off
; 0000 007E // Compare B Match Interrupt: Off
; 0000 007F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0080 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0081 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0082 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0083 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0084 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0085 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0086 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0087 
; 0000 0088 // Timer/Counter 2 initialization
; 0000 0089 // Clock source: System Clock
; 0000 008A // Clock value: Timer2 Stopped
; 0000 008B // Mode: Normal top=0xFF
; 0000 008C // OC2 output: Disconnected
; 0000 008D ASSR=0x00;
	OUT  0x22,R30
; 0000 008E TCCR2=0x00;
	OUT  0x25,R30
; 0000 008F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0090 OCR2=0x00;
	OUT  0x23,R30
; 0000 0091 
; 0000 0092 // External Interrupt(s) initialization
; 0000 0093 // INT0: On
; 0000 0094 // INT0 Mode: Rising Edge
; 0000 0095 // INT1: Off
; 0000 0096 GIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 0097 MCUCR=0x03;
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 0098 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0099 
; 0000 009A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 009B TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 009C 
; 0000 009D // UART initialization
; 0000 009E // UART disabled
; 0000 009F UCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00A0 
; 0000 00A1 // Analog Comparator initialization
; 0000 00A2 // Analog Comparator: Off
; 0000 00A3 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00A4 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00A5 
; 0000 00A6 // ADC initialization
; 0000 00A7 // ADC disabled
; 0000 00A8 ADCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 00A9 
; 0000 00AA // SPI initialization
; 0000 00AB // SPI disabled
; 0000 00AC SPCR=0x00;
	OUT  0xD,R30
; 0000 00AD 
; 0000 00AE // Alphanumeric LCD initialization
; 0000 00AF // Connections are specified in the
; 0000 00B0 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00B1 // RS - PORTD Bit 5
; 0000 00B2 // RD - PORTD Bit 4
; 0000 00B3 // EN - PORTD Bit 0
; 0000 00B4 // D4 - PORTB Bit 4
; 0000 00B5 // D5 - PORTB Bit 5
; 0000 00B6 // D6 - PORTB Bit 6
; 0000 00B7 // D7 - PORTB Bit 7
; 0000 00B8 // Characters/line: 16
; 0000 00B9 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00BA 
; 0000 00BB // Global enable interrupts
; 0000 00BC #asm("sei")
	sei
; 0000 00BD 
; 0000 00BE     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 00BF     lcd_putsf("This is a clock!");
	__POINTW2FN _0x0,0
	RCALL SUBOPT_0x2
; 0000 00C0     lcd_gotoxy(3,1);
; 0000 00C1     lcd_putsf("Verison 0.1");
	__POINTW2FN _0x0,17
	RCALL _lcd_putsf
; 0000 00C2     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _delay_ms
; 0000 00C3     lcd_clear();
	RCALL _lcd_clear
; 0000 00C4     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00C5     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 00C6     lcd_putsf("AD1999/12/31");
	__POINTW2FN _0x0,29
	RCALL SUBOPT_0x2
; 0000 00C7     lcd_gotoxy(3,1);
; 0000 00C8     lcd_putsf("00:00\'00\"0000");
	__POINTW2FN _0x0,42
	RCALL _lcd_putsf
; 0000 00C9     output_day();
	RCALL _output_day
; 0000 00CA     TCCR0=T0SET;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00CB       while (1)
_0x5:
; 0000 00CC       {
; 0000 00CD       // Place your code here
; 0000 00CE          delay_ms(8);
	LDI  R26,LOW(8)
	RCALL SUBOPT_0x3
; 0000 00CF          caculate();
	RCALL _caculate
; 0000 00D0          //output_time();
; 0000 00D1       }
	RJMP _0x5
; 0000 00D2 }
_0x8:
	RJMP _0x8
;
;void output_time()
; 0000 00D5 {
_output_time:
; 0000 00D6     unsigned char i;
; 0000 00D7     lcd_gotoxy(0,1);
	ST   -Y,R16
;	i -> R16
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x4
; 0000 00D8     lcd_putsf("   ");
	__POINTW2FN _0x0,56
	RCALL SUBOPT_0x2
; 0000 00D9     lcd_gotoxy(3,1); //hour
; 0000 00DA     d2ecoder(Hour);
	MOV  R26,R12
	RCALL SUBOPT_0x5
; 0000 00DB     lcd_puts(o2num);
; 0000 00DC     lcd_gotoxy(5,1);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x4
; 0000 00DD     lcd_putchar(':');
	LDI  R26,LOW(58)
	RCALL _lcd_putchar
; 0000 00DE     lcd_gotoxy(6,1); //minute
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x4
; 0000 00DF     d2ecoder(Minute);
	MOV  R26,R13
	RCALL SUBOPT_0x5
; 0000 00E0     lcd_puts(o2num);
; 0000 00E1     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x4
; 0000 00E2     lcd_putchar('\'');
	LDI  R26,LOW(39)
	RCALL _lcd_putchar
; 0000 00E3     lcd_gotoxy(9,1); //second
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x4
; 0000 00E4     d2ecoder(Second);
	MOV  R26,R14
	RCALL SUBOPT_0x5
; 0000 00E5     lcd_puts(o2num);
; 0000 00E6     lcd_gotoxy(11,1);
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x4
; 0000 00E7     lcd_putsf("     ");
	__POINTW2FN _0x0,60
	RCALL _lcd_putsf
; 0000 00E8 
; 0000 00E9     /*
; 0000 00EA     lcd_putchar('\"');
; 0000 00EB     lcd_gotoxy(12,1); //microsecond
; 0000 00EC     d2ecoder(microSecond);
; 0000 00ED     lcd_puts(o2num);
; 0000 00EE       */
; 0000 00EF 
; 0000 00F0 
; 0000 00F1 }
	LD   R16,Y+
	RET
;
;void output_day()
; 0000 00F4 {
_output_day:
; 0000 00F5     lcd_gotoxy(0,0);
	RCALL SUBOPT_0x1
; 0000 00F6     lcd_putsf("AD");
	__POINTW2FN _0x0,66
	RCALL _lcd_putsf
; 0000 00F7     lcd_gotoxy(2,0); //Year
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x6
; 0000 00F8     decoder(Year);
	__GETW2R 4,5
	RCALL _decoder
; 0000 00F9     lcd_puts(onum);
	LDI  R26,LOW(_onum)
	LDI  R27,HIGH(_onum)
	RCALL _lcd_puts
; 0000 00FA     lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	RCALL SUBOPT_0x6
; 0000 00FB     lcd_putchar('//');
	LDI  R26,LOW(47)
	RCALL _lcd_putchar
; 0000 00FC     lcd_gotoxy(7,0); //Month
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x6
; 0000 00FD     d2ecoder(Month);
	MOV  R26,R10
	RCALL SUBOPT_0x5
; 0000 00FE     lcd_puts(o2num);
; 0000 00FF     lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x6
; 0000 0100     lcd_putchar('//');
	LDI  R26,LOW(47)
	RCALL _lcd_putchar
; 0000 0101     lcd_gotoxy(10,0); //Day
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x6
; 0000 0102     d2ecoder(Day);
	MOV  R26,R11
	RCALL SUBOPT_0x5
; 0000 0103     lcd_puts(o2num);
; 0000 0104     lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x6
; 0000 0105     lcd_putsf("    ");
	__POINTW2FN _0x0,61
	RCALL _lcd_putsf
; 0000 0106 }
	RET
;
;void decoder(unsigned int inum)
; 0000 0109 {
_decoder:
; 0000 010A     unsigned char i;
; 0000 010B     if(inum<10)
	RCALL SUBOPT_0x7
;	inum -> Y+1
;	i -> R16
	BRSH _0x9
; 0000 010C     {
; 0000 010D         onum[3]=inum;
	LDD  R30,Y+1
	RCALL SUBOPT_0x8
; 0000 010E         onum[2]=0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x9
; 0000 010F         onum[1]=0x00;
; 0000 0110         onum[0]=0x00;
	RJMP _0x48
; 0000 0111     }
; 0000 0112     else if(inum<100 && inum>=10)
_0x9:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	BRSH _0xC
	RCALL SUBOPT_0xA
	SBIW R26,10
	BRSH _0xD
_0xC:
	RJMP _0xB
_0xD:
; 0000 0113     {
; 0000 0114         onum[3]=inum%10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
; 0000 0115         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0116         onum[2]=inum%10;
	RCALL SUBOPT_0x9
; 0000 0117         onum[1]=0x00;
; 0000 0118         onum[0]=0x00;
	RJMP _0x48
; 0000 0119     }
; 0000 011A     else if(inum<1000 && inum>=100)
_0xB:
	RCALL SUBOPT_0xE
	BRSH _0x10
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	BRSH _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 011B     {
; 0000 011C         onum[3]=inum%10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
; 0000 011D         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 011E         onum[2]=inum%10;
	__PUTB1MN _onum,2
; 0000 011F         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0120         onum[1]=inum%10;
	__PUTB1MN _onum,1
; 0000 0121         onum[0]=0x00;
	LDI  R30,LOW(0)
	RJMP _0x48
; 0000 0122     }
; 0000 0123     else if(inum<10000 && inum>=1000)
_0xF:
	RCALL SUBOPT_0xA
	CPI  R26,LOW(0x2710)
	LDI  R30,HIGH(0x2710)
	CPC  R27,R30
	BRSH _0x14
	RCALL SUBOPT_0xE
	BRSH _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 0124     {
; 0000 0125         onum[3]=inum%10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
; 0000 0126         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0127         onum[2]=inum%10;
	__PUTB1MN _onum,2
; 0000 0128         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0129         onum[1]=inum%10;
	__PUTB1MN _onum,1
; 0000 012A         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 012B         onum[0]=inum%10;
_0x48:
	STS  _onum,R30
; 0000 012C     }
; 0000 012D     for(i=0;i<4;i++)
_0x13:
	LDI  R16,LOW(0)
_0x17:
	CPI  R16,4
	BRSH _0x18
; 0000 012E     {
; 0000 012F         onum[i]=value2char(onum[i]);
	RCALL SUBOPT_0xF
	SUBI R30,LOW(-_onum)
	SBCI R31,HIGH(-_onum)
	PUSH R31
	PUSH R30
	LD   R26,Z
	RCALL _value2char
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0130     }
	SUBI R16,-1
	RJMP _0x17
_0x18:
; 0000 0131     return;
	RJMP _0x2020002
; 0000 0132 }
;
;void d2ecoder(unsigned int inum)
; 0000 0135 {
_d2ecoder:
; 0000 0136     unsigned char i;
; 0000 0137     if(inum<10)
	RCALL SUBOPT_0x7
;	inum -> Y+1
;	i -> R16
	BRSH _0x19
; 0000 0138     {
; 0000 0139         o2num[1]=inum;
	LDD  R30,Y+1
	__PUTB1MN _o2num,1
; 0000 013A         o2num[0]=0x00;
	LDI  R30,LOW(0)
	RJMP _0x49
; 0000 013B 
; 0000 013C     }
; 0000 013D     else if(inum<100 && inum>=10)
_0x19:
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	BRSH _0x1C
	RCALL SUBOPT_0xA
	SBIW R26,10
	BRSH _0x1D
_0x1C:
	RJMP _0x1B
_0x1D:
; 0000 013E     {
; 0000 013F         o2num[1]=inum%10;
	RCALL SUBOPT_0xC
	__PUTB1MN _o2num,1
; 0000 0140         inum=(inum-inum%10)/10;
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0141         o2num[0]=inum%10;
_0x49:
	STS  _o2num,R30
; 0000 0142     }
; 0000 0143     for(i=0;i<2;i++)
_0x1B:
	LDI  R16,LOW(0)
_0x1F:
	CPI  R16,2
	BRSH _0x20
; 0000 0144     {
; 0000 0145         o2num[i]=value2char(o2num[i]);
	RCALL SUBOPT_0xF
	SUBI R30,LOW(-_o2num)
	SBCI R31,HIGH(-_o2num)
	PUSH R31
	PUSH R30
	LD   R26,Z
	RCALL _value2char
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0146     }
	SUBI R16,-1
	RJMP _0x1F
_0x20:
; 0000 0147     return;
	RJMP _0x2020002
; 0000 0148 }
;
;unsigned char value2char(unsigned char value)
; 0000 014B {
_value2char:
; 0000 014C     if(value==0)
	ST   -Y,R26
;	value -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x21
; 0000 014D     {
; 0000 014E         return '0';
	LDI  R30,LOW(48)
	RJMP _0x2020001
; 0000 014F     }
; 0000 0150     else if(value ==1)
_0x21:
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x23
; 0000 0151     {
; 0000 0152         return '1';
	LDI  R30,LOW(49)
	RJMP _0x2020001
; 0000 0153     }
; 0000 0154     else if(value == 2)
_0x23:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BRNE _0x25
; 0000 0155     {
; 0000 0156         return '2';
	LDI  R30,LOW(50)
	RJMP _0x2020001
; 0000 0157     }
; 0000 0158     else if(value == 3)
_0x25:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BRNE _0x27
; 0000 0159     {
; 0000 015A         return '3';
	LDI  R30,LOW(51)
	RJMP _0x2020001
; 0000 015B     }
; 0000 015C     else if(value == 4)
_0x27:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0x29
; 0000 015D     {
; 0000 015E         return '4';
	LDI  R30,LOW(52)
	RJMP _0x2020001
; 0000 015F     }
; 0000 0160     else if(value == 5)
_0x29:
	LD   R26,Y
	CPI  R26,LOW(0x5)
	BRNE _0x2B
; 0000 0161     {
; 0000 0162         return '5';
	LDI  R30,LOW(53)
	RJMP _0x2020001
; 0000 0163     }
; 0000 0164     else if(value == 6)
_0x2B:
	LD   R26,Y
	CPI  R26,LOW(0x6)
	BRNE _0x2D
; 0000 0165     {
; 0000 0166         return '6';
	LDI  R30,LOW(54)
	RJMP _0x2020001
; 0000 0167     }
; 0000 0168     else if(value == 7)
_0x2D:
	LD   R26,Y
	CPI  R26,LOW(0x7)
	BRNE _0x2F
; 0000 0169     {
; 0000 016A         return '7';
	LDI  R30,LOW(55)
	RJMP _0x2020001
; 0000 016B     }
; 0000 016C     else if(value == 8)
_0x2F:
	LD   R26,Y
	CPI  R26,LOW(0x8)
	BRNE _0x31
; 0000 016D     {
; 0000 016E         return '8';
	LDI  R30,LOW(56)
	RJMP _0x2020001
; 0000 016F     }
; 0000 0170     else if(value == 9)
_0x31:
	LD   R26,Y
	CPI  R26,LOW(0x9)
	BRNE _0x33
; 0000 0171     {
; 0000 0172         return '9';
	LDI  R30,LOW(57)
	RJMP _0x2020001
; 0000 0173     }
; 0000 0174 }
_0x33:
	RJMP _0x2020001
;
;void caculate()
; 0000 0177 {
_caculate:
; 0000 0178     unsigned char eod=0,prt=0;
; 0000 0179     if(microSecond>100)
	RCALL __SAVELOCR2
;	eod -> R16
;	prt -> R17
	LDI  R16,0
	LDI  R17,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x34
; 0000 017A     {
; 0000 017B         Second++;
	INC  R14
; 0000 017C         microSecond = 0;
	CLR  R6
	CLR  R7
; 0000 017D         sysclk=0;
	CLR  R8
	CLR  R9
; 0000 017E         prt=1;
	LDI  R17,LOW(1)
; 0000 017F 
; 0000 0180     }
; 0000 0181     if(Second==60)
_0x34:
	LDI  R30,LOW(60)
	CP   R30,R14
	BRNE _0x35
; 0000 0182     {
; 0000 0183         Minute++;
	INC  R13
; 0000 0184         Second =0;
	CLR  R14
; 0000 0185         sysclk=0;
	CLR  R8
	CLR  R9
; 0000 0186 
; 0000 0187     }
; 0000 0188     if(Minute==60)
_0x35:
	LDI  R30,LOW(60)
	CP   R30,R13
	BRNE _0x36
; 0000 0189     {
; 0000 018A         Hour++;
	INC  R12
; 0000 018B         Minute = 0;
	CLR  R13
; 0000 018C     }
; 0000 018D     if(Hour==24)
_0x36:
	LDI  R30,LOW(24)
	CP   R30,R12
	BRNE _0x37
; 0000 018E     {
; 0000 018F         Day++;
	INC  R11
; 0000 0190         Hour = 0;
	CLR  R12
; 0000 0191         eod=1;
	LDI  R16,LOW(1)
; 0000 0192     }
; 0000 0193     if(Month==1 || Month==3 || Month==5 || Month==7 || Month==8 || Month==10 || Month ==12)
_0x37:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(3)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(5)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(7)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(8)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(10)
	CP   R30,R10
	BREQ _0x39
	LDI  R30,LOW(12)
	CP   R30,R10
	BRNE _0x38
_0x39:
; 0000 0194     {
; 0000 0195         if(Day==32)
	LDI  R30,LOW(32)
	CP   R30,R11
	BRNE _0x3B
; 0000 0196         {
; 0000 0197             Month++;
	INC  R10
; 0000 0198             Day = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0199         }
; 0000 019A     }
_0x3B:
; 0000 019B     else
	RJMP _0x3C
_0x38:
; 0000 019C     {
; 0000 019D         if(Month == 2 && Year%4!=0)
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x3E
	__GETW2R 4,5
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 019E         {
; 0000 019F             if(Day==29)
	LDI  R30,LOW(29)
	CP   R30,R11
	BREQ _0x4A
; 0000 01A0             {
; 0000 01A1                 Month++;
; 0000 01A2                 Day = 1;
; 0000 01A3             }
; 0000 01A4             else if(Day == 30)
	LDI  R30,LOW(30)
	CP   R30,R11
	BRNE _0x42
; 0000 01A5             {
; 0000 01A6                 Month++;
_0x4A:
	INC  R10
; 0000 01A7                 Day =1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 01A8             }
; 0000 01A9         }
_0x42:
; 0000 01AA         else
	RJMP _0x43
_0x3D:
; 0000 01AB         {
; 0000 01AC             if(Day==31)
	LDI  R30,LOW(31)
	CP   R30,R11
	BRNE _0x44
; 0000 01AD             {
; 0000 01AE                 Month++;
	INC  R10
; 0000 01AF                 Day = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 01B0             }
; 0000 01B1         }
_0x44:
_0x43:
; 0000 01B2     }
_0x3C:
; 0000 01B3     if(Month==13)
	LDI  R30,LOW(13)
	CP   R30,R10
	BRNE _0x45
; 0000 01B4     {
; 0000 01B5         Year++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 4,5,30,31
; 0000 01B6         Month=1;
	MOV  R10,R30
; 0000 01B7     }
; 0000 01B8     if(prt==1)
_0x45:
	CPI  R17,1
	BRNE _0x46
; 0000 01B9     {
; 0000 01BA        output_time();
	RCALL _output_time
; 0000 01BB     }
; 0000 01BC     if(eod==1)
_0x46:
	CPI  R16,1
	BRNE _0x47
; 0000 01BD     {
; 0000 01BE         output_day();
	RCALL _output_day
; 0000 01BF     }
; 0000 01C0 }
_0x47:
	RCALL __LOADLOCR2P
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0x30
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 5
	SBI  0x12,0
	__DELAY_USB 13
	CBI  0x12,0
	__DELAY_USB 13
	RJMP _0x2020001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x12,5
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,5
	RJMP _0x2020001
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R16
_0x2000008:
	RCALL SUBOPT_0xA
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R16
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x2020002
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R16
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM
	MOV  R30,R0
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R16
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x2020002:
	LDD  R16,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x11,0
	SBI  0x11,5
	SBI  0x11,4
	CBI  0x12,0
	CBI  0x12,5
	CBI  0x12,4
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x10
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET

	.DSEG
_onum:
	.BYTE 0x4
_o2num:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	__GETW2R 8,9
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2:
	RCALL _lcd_putsf
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x4:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x5:
	CLR  R27
	RCALL _d2ecoder
	LDI  R26,LOW(_o2num)
	LDI  R27,HIGH(_o2num)
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R16
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__PUTB1MN _onum,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	__PUTB1MN _onum,2
	LDI  R30,LOW(0)
	__PUTB1MN _onum,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0xA:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0xA
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xA
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STD  Y+1,R30
	STD  Y+1+1,R31
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xA
	CPI  R26,LOW(0x3E8)
	LDI  R30,HIGH(0x3E8)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	MOV  R30,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOV  R30,R26
	MOV  R31,R27
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOV  R30,R26
	MOV  R31,R27
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
