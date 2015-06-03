
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
	.DEF _fnc=R4
	.DEF _num_pointer=R5
	.DEF _dotA=R6
	.DEF _dotB=R7
	.DEF _dotC=R8
	.DEF _pressed=R9
	.DEF __lcd_x=R10
	.DEF __lcd_y=R11
	.DEF __lcd_maxx=R12

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0xEE,0xED,0xEB,0xE7,0xDE,0xDD,0xDB,0xD7
	.DB  0xBE,0xBD,0xBB,0xB7,0x7E,0x7D,0x7B,0x77
_0x7F:
	.DB  0x0,0x0,0xFF,0xFF,0x0,0xFF
_0x0:
	.DB  0x3D,0x20,0x56,0x65,0x72,0x69,0x73,0x6F
	.DB  0x6E,0x20,0x30,0x2E,0x31,0x20,0x3D,0x0
	.DB  0x43,0x61,0x6C,0x63,0x75,0x6C,0x61,0x63
	.DB  0x74,0x6F,0x72,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x10
	.DW  _Keypad
	.DW  _0x3*2

	.DW  0x06
	.DW  0x04
	.DW  _0x7F*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

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
;Project : Trial-7
;Version : 0.1
;Date    : 2015/5/13
;Author  : henry1758f@gmail.com
;Company : KUAS EE501
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
;#include <stdio.h>
;#include <stdlib.h>
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
;/*OTHER Definitions*/
;#define LCDbackground PORTD.PORTD6
;#define ADD 11
;#define DEC 12
;#define MUL 13
;#define DIV 14
;#define EQU 15
;
;//Global variables define
;unsigned char Keypad[16]={0xEE,0xED,0xEB,0xE7,
;                          0xDE,0xDD,0xDB,0xD7,
;                          0xBE,0xBD,0xBB,0xB7,
;                          0x7E,0x7D,0x7B,0x77};

	.DSEG
;unsigned char fnc=0,num_pointer=0,
;              dotA=0xFF, dotB=0xFF, dotC=0;
;double numA=0,numB=0,numC;
;unsigned char pressed=0xFF;
;
;
;/*Function Declear*/
;unsigned char input(unsigned char);
;void caculate(unsigned char );
;unsigned char printfnc(unsigned char);
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0042 {

	.CSEG
_ext_int0_isr:
	RCALL SUBOPT_0x0
; 0000 0043 // Place your code here
; 0000 0044 fnc=0;
	RCALL SUBOPT_0x1
; 0000 0045 num_pointer=0;
; 0000 0046 dotA=0xFF;
; 0000 0047 dotB=0xFF;
; 0000 0048 dotC=0;
; 0000 0049 numA=0;
	RCALL SUBOPT_0x2
; 0000 004A numB=0;
; 0000 004B numC=0;
; 0000 004C lcd_clear();
; 0000 004D 
; 0000 004E 
; 0000 004F }
	RJMP _0x7E
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0053 {
_timer0_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 0054     unsigned char kbsw[4]={0xF7,0xFB,0xFD,0xFE};
; 0000 0055     unsigned char i,j,error,none=0;
; 0000 0056     unsigned char num[5];
; 0000 0057     for(i=0;i<4;i++)
	SBIW R28,9
	LDI  R30,LOW(247)
	STD  Y+5,R30
	LDI  R30,LOW(251)
	STD  Y+6,R30
	LDI  R30,LOW(253)
	STD  Y+7,R30
	LDI  R30,LOW(254)
	STD  Y+8,R30
	RCALL __SAVELOCR4
;	kbsw -> Y+9
;	i -> R16
;	j -> R17
;	error -> R18
;	none -> R19
;	num -> Y+4
	LDI  R19,0
	LDI  R16,LOW(0)
_0x5:
	CPI  R16,4
	BRSH _0x6
; 0000 0058     {
; 0000 0059         PORTA=kbsw[i];
	MOV  R30,R16
	RCALL SUBOPT_0x3
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,9
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x1B,R30
; 0000 005A         for(j=0;j<16;j++)
	LDI  R17,LOW(0)
_0x8:
	CPI  R17,16
	BRSH _0x9
; 0000 005B         {
; 0000 005C             if(PINA==Keypad[j])
	IN   R30,0x19
	MOV  R26,R30
	MOV  R30,R17
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_Keypad)
	SBCI R31,HIGH(-_Keypad)
	LD   R30,Z
	CP   R30,R26
	BRNE _0xA
; 0000 005D             {
; 0000 005E                 if(pressed!=j)
	CP   R17,R9
	BREQ _0xB
; 0000 005F                 {
; 0000 0060                     error = input(j);
	MOV  R26,R17
	RCALL _input
	MOV  R18,R30
; 0000 0061                 }
; 0000 0062                 else
	RJMP _0xC
_0xB:
; 0000 0063                 {
; 0000 0064                     return;
	RJMP _0x7D
; 0000 0065                 }
_0xC:
; 0000 0066                 pressed = j;
	MOV  R9,R17
; 0000 0067                 TCNT0=0x00;
	RJMP _0x7C
; 0000 0068                 return;
; 0000 0069             }
; 0000 006A         }
_0xA:
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 006B     }
	SUBI R16,-1
	RJMP _0x5
_0x6:
; 0000 006C     if(none==0)
	CPI  R19,0
	BRNE _0xD
; 0000 006D     {
; 0000 006E         pressed=0xFF;
	LDI  R30,LOW(255)
	MOV  R9,R30
; 0000 006F     }
; 0000 0070 
; 0000 0071 
; 0000 0072     TCNT0=0x00;
_0xD:
_0x7C:
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0073 }
_0x7D:
	RCALL __LOADLOCR4
	ADIW R28,13
_0x7E:
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
;// Declare your global variables here
;
;void main(void)
; 0000 0078 {
_main:
; 0000 0079 // Declare your local variables here
; 0000 007A 
; 0000 007B // Input/Output Ports initialization
; 0000 007C // Port A initialization
; 0000 007D // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 007E // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 007F PORTA=0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 0080 DDRA=0x0F;
	LDI  R30,LOW(15)
	OUT  0x1A,R30
; 0000 0081 
; 0000 0082 // Port B initialization
; 0000 0083 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0084 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0085 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0086 DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 0087 
; 0000 0088 // Port C initialization
; 0000 0089 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 008A // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 008B PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 008C DDRC=0x00;
	OUT  0x14,R30
; 0000 008D 
; 0000 008E // Port D initialization
; 0000 008F // Func7=In Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=Out
; 0000 0090 // State7=T State6=1 State5=0 State4=0 State3=T State2=T State1=T State0=1
; 0000 0091 PORTD=0x41;
	LDI  R30,LOW(65)
	OUT  0x12,R30
; 0000 0092 DDRD=0x71;
	LDI  R30,LOW(113)
	OUT  0x11,R30
; 0000 0093 
; 0000 0094 // Timer/Counter 0 initialization
; 0000 0095 // Clock source: System Clock
; 0000 0096 // Clock value: Timer 0 Stopped
; 0000 0097 TCCR0=STOP;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0098 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0099 
; 0000 009A // Timer/Counter 1 initialization
; 0000 009B // Clock source: System Clock
; 0000 009C // Clock value: Timer1 Stopped
; 0000 009D // Mode: Normal top=0xFFFF
; 0000 009E // OC1A output: Discon.
; 0000 009F // OC1B output: Discon.
; 0000 00A0 // Noise Canceler: Off
; 0000 00A1 // Input Capture on Falling Edge
; 0000 00A2 // Timer1 Overflow Interrupt: Off
; 0000 00A3 // Input Capture Interrupt: Off
; 0000 00A4 // Compare A Match Interrupt: Off
; 0000 00A5 // Compare B Match Interrupt: Off
; 0000 00A6 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00A7 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00A8 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A9 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00AA OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00AB OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00AC OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00AD OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00AE 
; 0000 00AF // Timer/Counter 2 initialization
; 0000 00B0 // Clock source: System Clock
; 0000 00B1 // Clock value: Timer2 Stopped
; 0000 00B2 // Mode: Normal top=0xFF
; 0000 00B3 // OC2 output: Disconnected
; 0000 00B4 ASSR=0x00;
	OUT  0x22,R30
; 0000 00B5 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00B6 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B7 OCR2=0x00;
	OUT  0x23,R30
; 0000 00B8 
; 0000 00B9 // External Interrupt(s) initialization
; 0000 00BA // INT0: On
; 0000 00BB // INT0 Mode: Rising Edge
; 0000 00BC // INT1: Off
; 0000 00BD GIMSK=0x40;
	LDI  R30,LOW(64)
	OUT  0x3B,R30
; 0000 00BE MCUCR=0x03;
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 00BF GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00C0 
; 0000 00C1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C2 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 00C3 
; 0000 00C4 // UART initialization
; 0000 00C5 // UART disabled
; 0000 00C6 UCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xA,R30
; 0000 00C7 
; 0000 00C8 // Analog Comparator initialization
; 0000 00C9 // Analog Comparator: Off
; 0000 00CA // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00CB ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00CC 
; 0000 00CD // ADC initialization
; 0000 00CE // ADC disabled
; 0000 00CF ADCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x6,R30
; 0000 00D0 
; 0000 00D1 // SPI initialization
; 0000 00D2 // SPI disabled
; 0000 00D3 SPCR=0x00;
	OUT  0xD,R30
; 0000 00D4 
; 0000 00D5 // Alphanumeric LCD initialization
; 0000 00D6 // Connections are specified in the
; 0000 00D7 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00D8 // RS - PORTD Bit 5
; 0000 00D9 // RD - PORTD Bit 4
; 0000 00DA // EN - PORTD Bit 0
; 0000 00DB // D4 - PORTB Bit 0
; 0000 00DC // D5 - PORTB Bit 1
; 0000 00DD // D6 - PORTB Bit 2
; 0000 00DE // D7 - PORTB Bit 3
; 0000 00DF // Characters/line: 16
; 0000 00E0 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00E1 
; 0000 00E2 // Global enable interrupts
; 0000 00E3 #asm("sei")
	sei
; 0000 00E4 lcd_gotoxy(0,1);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 00E5 lcd_putsf("= Verison 0.1 =");
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 00E6 lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x6
; 0000 00E7 lcd_putsf("Calculactor");
	__POINTW2FN _0x0,16
	RCALL _lcd_putsf
; 0000 00E8 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00E9 lcd_clear();
	RCALL _lcd_clear
; 0000 00EA TCCR0=FOSC1024;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00EB 
; 0000 00EC while (1)
; 0000 00ED       {
; 0000 00EE 
; 0000 00EF             while(1);
_0x11:
	RJMP _0x11
; 0000 00F0 
; 0000 00F1       }
; 0000 00F2 }
_0x14:
	RJMP _0x14
;
;
;unsigned char input(unsigned char KEY)
; 0000 00F6 {
_input:
; 0000 00F7     unsigned char num[32];
; 0000 00F8     unsigned char i=0;
; 0000 00F9     unsigned char dotA_trans,dotB_trans;
; 0000 00FA     double KEY_dot=KEY;
; 0000 00FB     if(dotA==0xFF)
	ST   -Y,R26
	SBIW R28,36
	RCALL __SAVELOCR3
;	KEY -> Y+39
;	num -> Y+7
;	i -> R16
;	dotA_trans -> R17
;	dotB_trans -> R18
;	KEY_dot -> Y+3
	LDI  R16,0
	LDD  R30,Y+39
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	BRNE _0x15
; 0000 00FC     {
; 0000 00FD         dotA_trans=0;
	LDI  R17,LOW(0)
; 0000 00FE     }
; 0000 00FF     else
	RJMP _0x16
_0x15:
; 0000 0100     {
; 0000 0101         dotA_trans=dotA;
	MOV  R17,R6
; 0000 0102     }
_0x16:
; 0000 0103     if(dotB==0xFF)
	RCALL SUBOPT_0x9
	BRNE _0x17
; 0000 0104     {
; 0000 0105         dotB_trans=0;
	LDI  R18,LOW(0)
; 0000 0106     }
; 0000 0107     else
	RJMP _0x18
_0x17:
; 0000 0108     {
; 0000 0109         dotB_trans=dotB;
	MOV  R18,R7
; 0000 010A     }
_0x18:
; 0000 010B 
; 0000 010C     if(num_pointer==0)              //numA Input
	TST  R5
	BREQ PC+2
	RJMP _0x19
; 0000 010D     {
; 0000 010E         /*numA Input*/
; 0000 010F         if(KEY<10 && dotA==0xFF)
	RCALL SUBOPT_0xA
	BRSH _0x1B
	RCALL SUBOPT_0x8
	BREQ _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
; 0000 0110         {
; 0000 0111             numA=numA*10+KEY;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 0112             //sprintf(num,"%f",numA);
; 0000 0113             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0xF
; 0000 0114             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x10
; 0000 0115             lcd_puts(num);
; 0000 0116         }
; 0000 0117         else if(KEY<10 && dotA!=0xFF)
	RJMP _0x1D
_0x1A:
	RCALL SUBOPT_0xA
	BRSH _0x1F
	RCALL SUBOPT_0x8
	BRNE _0x20
_0x1F:
	RJMP _0x1E
_0x20:
; 0000 0118         {
; 0000 0119             for(i=0;i<dotA_trans;i++)
	LDI  R16,LOW(0)
_0x22:
	CP   R16,R17
	BRSH _0x23
; 0000 011A             {
; 0000 011B                 KEY_dot/=10;
	RCALL SUBOPT_0x11
; 0000 011C             }
	SUBI R16,-1
	RJMP _0x22
_0x23:
; 0000 011D             numA=(numA+KEY_dot);
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0xB
	RCALL __ADDF12
	RCALL SUBOPT_0xE
; 0000 011E             //sprintf(num,"%f",numA);
; 0000 011F             dotA++;
	INC  R6
; 0000 0120             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0xF
; 0000 0121             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x10
; 0000 0122             lcd_puts(num);
; 0000 0123         }
; 0000 0124         else if(KEY==10 && dotA==0xFF)
	RJMP _0x24
_0x1E:
	RCALL SUBOPT_0xA
	BRNE _0x26
	RCALL SUBOPT_0x8
	BREQ _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 0125         {
; 0000 0126             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
; 0000 0127             dotA=1;
	RCALL SUBOPT_0x15
; 0000 0128             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x10
; 0000 0129             lcd_puts(num);
; 0000 012A             lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0000 012B         }
; 0000 012C         else if(KEY==ADD)
	RJMP _0x28
_0x25:
	LDD  R26,Y+39
	CPI  R26,LOW(0xB)
	BRNE _0x29
; 0000 012D         {
; 0000 012E             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 012F             //lcd_puts(num);
; 0000 0130             lcd_putchar('+');
	LDI  R26,LOW(43)
	RCALL SUBOPT_0x17
; 0000 0131             fnc=ADD;
; 0000 0132             num_pointer=1;
; 0000 0133         }
; 0000 0134         else if(KEY==DEC)
	RJMP _0x2A
_0x29:
	LDD  R26,Y+39
	CPI  R26,LOW(0xC)
	BRNE _0x2B
; 0000 0135         {
; 0000 0136             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 0137             //lcd_puts(num);
; 0000 0138             lcd_putchar('-');
	LDI  R26,LOW(45)
	RCALL SUBOPT_0x18
; 0000 0139             fnc=DEC;
; 0000 013A             num_pointer=1;
; 0000 013B         }
; 0000 013C         else if(KEY==MUL)
	RJMP _0x2C
_0x2B:
	LDD  R26,Y+39
	CPI  R26,LOW(0xD)
	BRNE _0x2D
; 0000 013D         {
; 0000 013E             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 013F             //lcd_puts(num);
; 0000 0140             lcd_putchar('*');
	LDI  R26,LOW(42)
	RCALL SUBOPT_0x19
; 0000 0141             fnc=MUL;
; 0000 0142             num_pointer=1;
; 0000 0143         }
; 0000 0144         else if(KEY==DIV)
	RJMP _0x2E
_0x2D:
	LDD  R26,Y+39
	CPI  R26,LOW(0xE)
	BRNE _0x2F
; 0000 0145         {
; 0000 0146             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 0147             //lcd_puts(num);
; 0000 0148             lcd_putchar('/');
	LDI  R26,LOW(47)
	RCALL SUBOPT_0x1A
; 0000 0149             fnc=DIV;
; 0000 014A             num_pointer=1;
; 0000 014B         }
; 0000 014C         else if(KEY==EQU)
	RJMP _0x30
_0x2F:
	LDD  R26,Y+39
	CPI  R26,LOW(0xF)
	BRNE _0x31
; 0000 014D         {
; 0000 014E             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 014F             //lcd_puts(num);
; 0000 0150             lcd_putchar('=');
	RCALL SUBOPT_0x1B
; 0000 0151             num_pointer=2;
; 0000 0152             numC=numA;
	RCALL SUBOPT_0x1C
; 0000 0153             ftoa(numC,dotA_trans,num);
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x14
; 0000 0154             lcd_gotoxy(0,1);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0155             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 0156             fnc=EQU;
	LDI  R30,LOW(15)
	MOV  R4,R30
; 0000 0157         }
; 0000 0158 
; 0000 0159     }
_0x31:
_0x30:
_0x2E:
_0x2C:
_0x2A:
_0x28:
_0x24:
_0x1D:
; 0000 015A     else if(num_pointer==1)             //numB Input
	RJMP _0x32
_0x19:
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x33
; 0000 015B     {
; 0000 015C         /*numB Input*/
; 0000 015D         if(KEY<10 && dotB==0xFF)
	RCALL SUBOPT_0xA
	BRSH _0x35
	RCALL SUBOPT_0x9
	BREQ _0x36
_0x35:
	RJMP _0x34
_0x36:
; 0000 015E         {
; 0000 015F             numB=numB*10+KEY;
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x20
; 0000 0160             //sprintf(num,"%f",numA);
; 0000 0161             ftoa(numB,dotB_trans,num);
	RCALL SUBOPT_0x21
	RJMP _0x7B
; 0000 0162             lcd_gotoxy(0,1);
; 0000 0163             lcd_puts(num);
; 0000 0164         }
; 0000 0165         else if(KEY<10 && dotB!=0xFF)
_0x34:
	RCALL SUBOPT_0xA
	BRSH _0x39
	RCALL SUBOPT_0x9
	BRNE _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 0166         {
; 0000 0167             for(i=0;i<dotB_trans;i++)
	LDI  R16,LOW(0)
_0x3C:
	CP   R16,R18
	BRSH _0x3D
; 0000 0168             {
; 0000 0169                 KEY_dot/=10;
	RCALL SUBOPT_0x11
; 0000 016A             }
	SUBI R16,-1
	RJMP _0x3C
_0x3D:
; 0000 016B             numB=(numB+KEY_dot);
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x1F
	RCALL __ADDF12
	RCALL SUBOPT_0x20
; 0000 016C             //sprintf(num,"%f",numA);
; 0000 016D             dotB++;
	INC  R7
; 0000 016E             ftoa(numB,dotB_trans,num);
	RCALL SUBOPT_0x21
	RJMP _0x7B
; 0000 016F             lcd_gotoxy(0,1);
; 0000 0170             lcd_puts(num);
; 0000 0171         }
; 0000 0172         else if(KEY==10 && dotB==0xFF)
_0x38:
	RCALL SUBOPT_0xA
	BRNE _0x40
	RCALL SUBOPT_0x9
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 0173         {
; 0000 0174             ftoa(numB,dotB_trans,num);
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
; 0000 0175             dotB=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0176             lcd_gotoxy(0,1);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 0177             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 0178             lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0000 0179         }
; 0000 017A         else if(KEY==ADD)
	RJMP _0x42
_0x3F:
	LDD  R26,Y+39
	CPI  R26,LOW(0xB)
	BRNE _0x43
; 0000 017B         {
; 0000 017C             caculate(fnc);
	RCALL SUBOPT_0x23
; 0000 017D             lcd_clear();
; 0000 017E             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x24
; 0000 017F             ftoa(numC,dotC,num);
; 0000 0180             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 0181             numB=0;dotB=0;numA=numC;
	RCALL SUBOPT_0x25
; 0000 0182 
; 0000 0183             lcd_gotoxy(15,0);
; 0000 0184             //lcd_puts(num);
; 0000 0185             lcd_putchar('+');
	LDI  R26,LOW(43)
	RCALL SUBOPT_0x26
; 0000 0186             num_pointer=1;
; 0000 0187             fnc=ADD;
	LDI  R30,LOW(11)
	MOV  R4,R30
; 0000 0188         }
; 0000 0189         else if(KEY==DEC)
	RJMP _0x44
_0x43:
	LDD  R26,Y+39
	CPI  R26,LOW(0xC)
	BRNE _0x45
; 0000 018A         {
; 0000 018B             caculate(fnc);
	RCALL SUBOPT_0x23
; 0000 018C             lcd_clear();
; 0000 018D             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x24
; 0000 018E             ftoa(numC,dotC,num);
; 0000 018F             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 0190             numB=0;dotB=0;numA=numC;
	RCALL SUBOPT_0x25
; 0000 0191 
; 0000 0192             lcd_gotoxy(15,0);
; 0000 0193             //lcd_puts(num);
; 0000 0194             lcd_putchar('-');
	LDI  R26,LOW(45)
	RCALL SUBOPT_0x26
; 0000 0195             num_pointer=1;
; 0000 0196             fnc=DEC;
	LDI  R30,LOW(12)
	MOV  R4,R30
; 0000 0197         }
; 0000 0198         else if(KEY==MUL)
	RJMP _0x46
_0x45:
	LDD  R26,Y+39
	CPI  R26,LOW(0xD)
	BRNE _0x47
; 0000 0199         {
; 0000 019A             caculate(fnc);
	RCALL SUBOPT_0x23
; 0000 019B             lcd_clear();
; 0000 019C             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x24
; 0000 019D             ftoa(numC,dotC,num);
; 0000 019E             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 019F             numB=0;dotB=0;numA=numC;
	RCALL SUBOPT_0x25
; 0000 01A0 
; 0000 01A1             lcd_gotoxy(15,0);
; 0000 01A2             //lcd_puts(num);
; 0000 01A3             lcd_putchar('*');
	LDI  R26,LOW(42)
	RCALL SUBOPT_0x26
; 0000 01A4             num_pointer=1;
; 0000 01A5             fnc=MUL;
	LDI  R30,LOW(13)
	MOV  R4,R30
; 0000 01A6         }
; 0000 01A7         else if(KEY==DIV)
	RJMP _0x48
_0x47:
	LDD  R26,Y+39
	CPI  R26,LOW(0xE)
	BRNE _0x49
; 0000 01A8         {
; 0000 01A9             caculate(fnc);
	RCALL SUBOPT_0x23
; 0000 01AA             lcd_clear();
; 0000 01AB             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x24
; 0000 01AC             ftoa(numC,dotC,num);
; 0000 01AD             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 01AE             numB=0;dotB=0;numA=numC;
	RCALL SUBOPT_0x25
; 0000 01AF 
; 0000 01B0             lcd_gotoxy(15,0);
; 0000 01B1             //lcd_puts(num);
; 0000 01B2             lcd_putchar('/');
	LDI  R26,LOW(47)
	RCALL SUBOPT_0x26
; 0000 01B3             num_pointer=1;
; 0000 01B4             fnc=DIV;
	LDI  R30,LOW(14)
	MOV  R4,R30
; 0000 01B5         }
; 0000 01B6         else if(KEY==EQU)
	RJMP _0x4A
_0x49:
	LDD  R26,Y+39
	CPI  R26,LOW(0xF)
	BRNE _0x4B
; 0000 01B7         {
; 0000 01B8             if(dotA_trans!=0)
	CPI  R17,0
	BREQ _0x4C
; 0000 01B9             {
; 0000 01BA                 dotA_trans--;
	SUBI R17,1
; 0000 01BB             }
; 0000 01BC             if(dotB_trans!=0)
_0x4C:
	CPI  R18,0
	BREQ _0x4D
; 0000 01BD             {
; 0000 01BE                 dotB_trans--;
	SUBI R18,1
; 0000 01BF             }
; 0000 01C0             lcd_clear();
_0x4D:
	RCALL _lcd_clear
; 0000 01C1             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0xF
; 0000 01C2             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x10
; 0000 01C3             lcd_puts(num);
; 0000 01C4             lcd_putchar(printfnc(fnc));
	MOV  R26,R4
	RCALL _printfnc
	MOV  R26,R30
	RCALL _lcd_putchar
; 0000 01C5             ftoa(numB,dotB_trans,num);
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
; 0000 01C6             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 01C7 
; 0000 01C8 
; 0000 01C9             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 01CA             //lcd_puts(num);
; 0000 01CB             lcd_putchar('=');
	RCALL SUBOPT_0x1B
; 0000 01CC             num_pointer=2;
; 0000 01CD             caculate(fnc);
	MOV  R26,R4
	RCALL _caculate
; 0000 01CE             ftoa(numC,dotC,num);
	RCALL SUBOPT_0x1D
	RCALL __PUTPARD1
	ST   -Y,R8
_0x7B:
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,12
	RCALL _ftoa
; 0000 01CF             lcd_gotoxy(0,1);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
; 0000 01D0             lcd_puts(num);
	RCALL SUBOPT_0x1E
; 0000 01D1         }
; 0000 01D2     }
_0x4B:
_0x4A:
_0x48:
_0x46:
_0x44:
_0x42:
; 0000 01D3 
; 0000 01D4     else if(num_pointer==2)              //numC Result
	RJMP _0x4E
_0x33:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x4F
; 0000 01D5     {
; 0000 01D6         /*numC Result*/
; 0000 01D7         if(KEY<10)
	RCALL SUBOPT_0xA
	BRSH _0x50
; 0000 01D8         {
; 0000 01D9             fnc=0;
	RCALL SUBOPT_0x1
; 0000 01DA             num_pointer=0;
; 0000 01DB             dotA=0xFF;
; 0000 01DC             dotB=0xFF;
; 0000 01DD             dotC=0;
; 0000 01DE             dotA_trans=0;
	LDI  R17,LOW(0)
; 0000 01DF             dotB_trans=0;
	LDI  R18,LOW(0)
; 0000 01E0             numA=0;
	RCALL SUBOPT_0x2
; 0000 01E1             numB=0;
; 0000 01E2             numC=0;
; 0000 01E3             lcd_clear();
; 0000 01E4 
; 0000 01E5             numA=numA*10+KEY;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0000 01E6             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0xF
; 0000 01E7             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x10
; 0000 01E8             lcd_puts(num);
; 0000 01E9         }
; 0000 01EA         else if(KEY==10)
	RJMP _0x51
_0x50:
	RCALL SUBOPT_0xA
	BRNE _0x52
; 0000 01EB         {
; 0000 01EC             numA=numC;
	RCALL SUBOPT_0x27
; 0000 01ED             fnc=0;
	CLR  R4
; 0000 01EE             num_pointer=0;
	CLR  R5
; 0000 01EF             dotA=1;
	RCALL SUBOPT_0x15
; 0000 01F0             dotB=0xFF;
	RCALL SUBOPT_0x28
; 0000 01F1             dotC=0;
	CLR  R8
; 0000 01F2             dotA_trans=0;
	LDI  R17,LOW(0)
; 0000 01F3             dotB_trans=0;
	RCALL SUBOPT_0x29
; 0000 01F4             numB=0;
; 0000 01F5             numC=0;
; 0000 01F6             lcd_clear();
; 0000 01F7 
; 0000 01F8 
; 0000 01F9 
; 0000 01FA             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0x14
; 0000 01FB             dotA=1;
	RCALL SUBOPT_0x15
; 0000 01FC             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x10
; 0000 01FD             lcd_puts(num);
; 0000 01FE             lcd_putchar('.');
	LDI  R26,LOW(46)
	RCALL _lcd_putchar
; 0000 01FF         }
; 0000 0200         else if(KEY==ADD)
	RJMP _0x53
_0x52:
	LDD  R26,Y+39
	CPI  R26,LOW(0xB)
	BRNE _0x54
; 0000 0201         {
; 0000 0202             numA=numC;
	RCALL SUBOPT_0x27
; 0000 0203             fnc=ADD;
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x2A
; 0000 0204             num_pointer=1;
; 0000 0205             dotA=dotC;
; 0000 0206             dotB=0xFF;
; 0000 0207             dotA_trans=dotC;
	RCALL SUBOPT_0x2B
; 0000 0208             dotC=0;
; 0000 0209             dotB_trans=0;
; 0000 020A             numB=0;
; 0000 020B             numC=0;
; 0000 020C             lcd_clear();
; 0000 020D 
; 0000 020E 
; 0000 020F             ftoa(numA,dotA,num);
	RCALL __PUTPARD1
	ST   -Y,R6
	RCALL SUBOPT_0x22
; 0000 0210             dotA=1;
	RCALL SUBOPT_0x15
; 0000 0211             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x10
; 0000 0212             lcd_puts(num);
; 0000 0213 
; 0000 0214             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 0215             //lcd_puts(num);
; 0000 0216             lcd_putchar('+');
	LDI  R26,LOW(43)
	RCALL SUBOPT_0x17
; 0000 0217             fnc=ADD;
; 0000 0218             num_pointer=1;
; 0000 0219         }
; 0000 021A         else if(KEY==DEC)
	RJMP _0x55
_0x54:
	LDD  R26,Y+39
	CPI  R26,LOW(0xC)
	BRNE _0x56
; 0000 021B         {
; 0000 021C             numA=numC;
	RCALL SUBOPT_0x27
; 0000 021D             fnc=DEC;
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x2A
; 0000 021E             num_pointer=1;
; 0000 021F             dotA=dotC;
; 0000 0220             dotB=0xFF;
; 0000 0221             dotA_trans=dotC;
	RCALL SUBOPT_0x2B
; 0000 0222             dotC=0;
; 0000 0223             dotB_trans=0;
; 0000 0224             numB=0;
; 0000 0225             numC=0;
; 0000 0226             lcd_clear();
; 0000 0227 
; 0000 0228 
; 0000 0229             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0x14
; 0000 022A             dotA=1;
	RCALL SUBOPT_0x15
; 0000 022B             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x10
; 0000 022C             lcd_puts(num);
; 0000 022D 
; 0000 022E             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 022F             //lcd_puts(num);
; 0000 0230             lcd_putchar('-');
	LDI  R26,LOW(45)
	RCALL SUBOPT_0x18
; 0000 0231             fnc=DEC;
; 0000 0232             num_pointer=1;
; 0000 0233         }
; 0000 0234         else if(KEY==MUL)
	RJMP _0x57
_0x56:
	LDD  R26,Y+39
	CPI  R26,LOW(0xD)
	BRNE _0x58
; 0000 0235         {
; 0000 0236             numA=numC;
	RCALL SUBOPT_0x27
; 0000 0237             fnc=MUL;
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x2A
; 0000 0238             num_pointer=1;
; 0000 0239             dotA=dotC;
; 0000 023A             dotB=0xFF;
; 0000 023B             dotA_trans=dotC;
	RCALL SUBOPT_0x2B
; 0000 023C             dotC=0;
; 0000 023D             dotB_trans=0;
; 0000 023E             numB=0;
; 0000 023F             numC=0;
; 0000 0240             lcd_clear();
; 0000 0241 
; 0000 0242 
; 0000 0243             ftoa(numA,dotA_trans,num);
	RCALL SUBOPT_0x14
; 0000 0244             dotA=1;
	RCALL SUBOPT_0x15
; 0000 0245             lcd_gotoxy(0,0);
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x10
; 0000 0246             lcd_puts(num);
; 0000 0247 
; 0000 0248             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 0249             //lcd_puts(num);
; 0000 024A             lcd_putchar('*');
	LDI  R26,LOW(42)
	RCALL SUBOPT_0x19
; 0000 024B             fnc=MUL;
; 0000 024C             num_pointer=1;
; 0000 024D         }
; 0000 024E         else if(KEY==DIV)
	RJMP _0x59
_0x58:
	LDD  R26,Y+39
	CPI  R26,LOW(0xE)
	BRNE _0x5A
; 0000 024F         {
; 0000 0250             numA=numC;
	RCALL SUBOPT_0x27
; 0000 0251             fnc=DIV;
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x2A
; 0000 0252             num_pointer=1;
; 0000 0253             dotA=dotC;
; 0000 0254             dotB=0xFF;
; 0000 0255             dotA_trans=dotC;
	MOV  R17,R8
; 0000 0256             dotC=0;
	CLR  R8
; 0000 0257             dotB_trans=0;
	LDI  R18,LOW(0)
; 0000 0258             numB=0;
	LDI  R30,LOW(0)
	STS  _numB,R30
	STS  _numB+1,R30
	STS  _numB+2,R30
	STS  _numB+3,R30
; 0000 0259             numC=0;
	STS  _numC,R30
	STS  _numC+1,R30
	STS  _numC+2,R30
	STS  _numC+3,R30
; 0000 025A             lcd_clear();
	RCALL _lcd_clear
; 0000 025B 
; 0000 025C             lcd_gotoxy(15,0);
	RCALL SUBOPT_0x16
; 0000 025D             //lcd_puts(num);
; 0000 025E             lcd_putchar('/');
	LDI  R26,LOW(47)
	RCALL SUBOPT_0x1A
; 0000 025F             fnc=DIV;
; 0000 0260             num_pointer=1;
; 0000 0261         }
; 0000 0262         else if(KEY==EQU)
_0x5A:
; 0000 0263         {   /*
; 0000 0264             lcd_gotoxy(15,0);
; 0000 0265             //lcd_puts(num);
; 0000 0266             lcd_putchar('=');
; 0000 0267             num_pointer=2;
; 0000 0268             numA=numC;
; 0000 0269             ftoa(numC,dotC,num);
; 0000 026A             lcd_gotoxy(0,1);
; 0000 026B             lcd_puts(num);
; 0000 026C             fnc=EQU;*/
; 0000 026D         }
; 0000 026E 
; 0000 026F     }
_0x59:
_0x57:
_0x55:
_0x53:
_0x51:
; 0000 0270 
; 0000 0271 }
_0x4F:
_0x4E:
_0x32:
	RCALL __LOADLOCR3
	ADIW R28,40
	RET
;
;void caculate(unsigned char f)
; 0000 0274 {
_caculate:
; 0000 0275     if(f==ADD)
	ST   -Y,R26
;	f -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x5D
; 0000 0276     {
; 0000 0277         if(dotA!=0xFF)
	RCALL SUBOPT_0x8
	BREQ _0x5E
; 0000 0278         {
; 0000 0279             dotC=dotA-1;
	RCALL SUBOPT_0x2C
; 0000 027A         }
; 0000 027B         if(dotB!=0xFF)
_0x5E:
	RCALL SUBOPT_0x9
	BREQ _0x5F
; 0000 027C         {
; 0000 027D             if(dotA==255 || dotB>dotA)
	RCALL SUBOPT_0x8
	BREQ _0x61
	CP   R6,R7
	BRSH _0x60
_0x61:
; 0000 027E             {
; 0000 027F                 dotC=dotB-1;
	MOV  R30,R7
	SUBI R30,LOW(1)
	MOV  R8,R30
; 0000 0280             }
; 0000 0281 
; 0000 0282         }
_0x60:
; 0000 0283         numC=numA+numB;
_0x5F:
	RCALL SUBOPT_0x2D
	RCALL __ADDF12
	RCALL SUBOPT_0x2E
; 0000 0284         return;
	RJMP _0x20C0002
; 0000 0285     }
; 0000 0286     else if(f==DEC)
_0x5D:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0x64
; 0000 0287     {
; 0000 0288        if(dotA!=0xFF)
	RCALL SUBOPT_0x8
	BREQ _0x65
; 0000 0289         {
; 0000 028A             dotC=dotA-1;
	RCALL SUBOPT_0x2C
; 0000 028B         }
; 0000 028C         if(dotB!=0xFF)
_0x65:
	RCALL SUBOPT_0x9
	BREQ _0x66
; 0000 028D         {
; 0000 028E             if(dotA==255 || dotB>dotA)
	RCALL SUBOPT_0x8
	BREQ _0x68
	CP   R6,R7
	BRSH _0x67
_0x68:
; 0000 028F             {
; 0000 0290                 dotC=dotB-1;
	MOV  R30,R7
	SUBI R30,LOW(1)
	MOV  R8,R30
; 0000 0291             }
; 0000 0292         }
_0x67:
; 0000 0293         numC=numA-numB;
_0x66:
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x13
	RCALL __SUBF12
	RCALL SUBOPT_0x2E
; 0000 0294         return;
	RJMP _0x20C0002
; 0000 0295     }
; 0000 0296     else if(f==MUL)
_0x64:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x6B
; 0000 0297     {
; 0000 0298         if(dotA!=0xFF)
	RCALL SUBOPT_0x8
	BREQ _0x6C
; 0000 0299         {
; 0000 029A             dotC=dotA-1;
	RCALL SUBOPT_0x2C
; 0000 029B         }
; 0000 029C         if(dotB!=0xFF)
_0x6C:
	RCALL SUBOPT_0x9
	BREQ _0x6D
; 0000 029D         {
; 0000 029E             dotC+=dotB-1;
	MOV  R30,R7
	SUBI R30,LOW(1)
	ADD  R8,R30
; 0000 029F         }
; 0000 02A0         numC=numA*numB;
_0x6D:
	RCALL SUBOPT_0x2D
	RCALL __MULF12
	RCALL SUBOPT_0x2E
; 0000 02A1         return;
	RJMP _0x20C0002
; 0000 02A2     }
; 0000 02A3     else if(f==DIV)
_0x6B:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0x6F
; 0000 02A4     {
; 0000 02A5         dotC=6;
	LDI  R30,LOW(6)
	MOV  R8,R30
; 0000 02A6         numC=numA/numB;
	RCALL SUBOPT_0x2D
	RCALL __DIVF21
	RCALL SUBOPT_0x2E
; 0000 02A7         return;
	RJMP _0x20C0002
; 0000 02A8     }
; 0000 02A9     else if(f==EQU)
_0x6F:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x71
; 0000 02AA     {
; 0000 02AB         numC=numA;
	RCALL SUBOPT_0x1C
; 0000 02AC         dotC=dotA;
	MOV  R8,R6
; 0000 02AD         return;
	RJMP _0x20C0002
; 0000 02AE     }
; 0000 02AF }
_0x71:
	RJMP _0x20C0002
;
;unsigned char printfnc(unsigned char f)
; 0000 02B2 {
_printfnc:
; 0000 02B3     if(f==ADD)
	ST   -Y,R26
;	f -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0xB)
	BRNE _0x72
; 0000 02B4     {
; 0000 02B5         return '+';
	LDI  R30,LOW(43)
	RJMP _0x20C0002
; 0000 02B6     }
; 0000 02B7     else if(f==DEC)
_0x72:
	LD   R26,Y
	CPI  R26,LOW(0xC)
	BRNE _0x74
; 0000 02B8     {
; 0000 02B9         return '-';
	LDI  R30,LOW(45)
	RJMP _0x20C0002
; 0000 02BA     }
; 0000 02BB     else if(f==MUL)
_0x74:
	LD   R26,Y
	CPI  R26,LOW(0xD)
	BRNE _0x76
; 0000 02BC     {
; 0000 02BD         return '*';
	LDI  R30,LOW(42)
	RJMP _0x20C0002
; 0000 02BE     }
; 0000 02BF     else if(f==DIV)
_0x76:
	LD   R26,Y
	CPI  R26,LOW(0xE)
	BRNE _0x78
; 0000 02C0     {
; 0000 02C1         return '/';
	LDI  R30,LOW(47)
	RJMP _0x20C0002
; 0000 02C2     }
; 0000 02C3     else if(f==EQU)
_0x78:
	LD   R26,Y
	CPI  R26,LOW(0xF)
	BRNE _0x7A
; 0000 02C4     {
; 0000 02C5         return '=';
	LDI  R30,LOW(61)
	RJMP _0x20C0002
; 0000 02C6     }
; 0000 02C7 
; 0000 02C8 }
_0x7A:
	RJMP _0x20C0002
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0x30
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_ftoa:
	RCALL SUBOPT_0x2F
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x202000D
	RCALL SUBOPT_0x30
	__POINTW2FN _0x2020000,0
	RCALL _strcpyf
	RJMP _0x20C0005
_0x202000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x202000C
	RCALL SUBOPT_0x30
	__POINTW2FN _0x2020000,1
	RCALL _strcpyf
	RJMP _0x20C0005
_0x202000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x202000F
	RCALL SUBOPT_0x31
	RCALL __ANEGF1
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x33
	LDI  R30,LOW(45)
	ST   X,R30
_0x202000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2020010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2020010:
	LDD  R16,Y+8
_0x2020011:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x2020013
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	RJMP _0x2020011
_0x2020013:
	RCALL SUBOPT_0x37
	RCALL __ADDF12
	RCALL SUBOPT_0x32
	LDI  R16,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x36
_0x2020014:
	RCALL SUBOPT_0x37
	RCALL __CMPF12
	BRLO _0x2020016
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0xC
	RCALL __MULF12
	RCALL SUBOPT_0x36
	SUBI R16,-LOW(1)
	CPI  R16,39
	BRLO _0x2020017
	RCALL SUBOPT_0x30
	__POINTW2FN _0x2020000,5
	RCALL _strcpyf
	RJMP _0x20C0005
_0x2020017:
	RJMP _0x2020014
_0x2020016:
	CPI  R16,0
	BRNE _0x2020018
	RCALL SUBOPT_0x33
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2020019
_0x2020018:
_0x202001A:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x202001C
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RCALL __MOVED12
	RCALL _floor
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x37
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R17,R30
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x34
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x39
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x32
	RJMP _0x202001A
_0x202001C:
_0x2020019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0004
	RCALL SUBOPT_0x33
	LDI  R30,LOW(46)
	ST   X,R30
_0x202001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2020020
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0xC
	RCALL __MULF12
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x31
	RCALL __CFD1U
	MOV  R17,R30
	RCALL SUBOPT_0x33
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x32
	RJMP _0x202001E
_0x2020020:
_0x20C0004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET

	.DSEG

	.CSEG
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
__lcd_write_nibble_G102:
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF0)
	MOV  R26,R30
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 5
	SBI  0x12,0
	__DELAY_USB 13
	CBI  0x12,0
	__DELAY_USB 13
	RJMP _0x20C0002
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 133
	RJMP _0x20C0002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R10,Y+1
	LDD  R11,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x3A
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x3A
	LDI  R30,LOW(0)
	MOV  R11,R30
	MOV  R10,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040005
	CP   R10,R12
	BRLO _0x2040004
_0x2040005:
	RCALL SUBOPT_0x4
	INC  R11
	MOV  R26,R11
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040007
	RJMP _0x20C0002
_0x2040007:
_0x2040004:
	INC  R10
	SBI  0x12,5
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,5
	RJMP _0x20C0002
_lcd_puts:
	RCALL SUBOPT_0x2F
	ST   -Y,R16
_0x2040008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x204000A
	MOV  R26,R16
	RCALL _lcd_putchar
	RJMP _0x2040008
_0x204000A:
	RJMP _0x20C0003
_lcd_putsf:
	RCALL SUBOPT_0x2F
	ST   -Y,R16
_0x204000B:
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
	BREQ _0x204000D
	MOV  R26,R16
	RCALL _lcd_putchar
	RJMP _0x204000B
_0x204000D:
_0x20C0003:
	LDD  R16,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF)
	OUT  0x17,R30
	SBI  0x11,0
	SBI  0x11,5
	SBI  0x11,4
	CBI  0x12,0
	CBI  0x12,5
	CBI  0x12,4
	LDD  R12,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3B
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G102
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
_0x20C0002:
	ADIW R28,1
	RET

	.CSEG

	.CSEG
_strcpyf:
	RCALL SUBOPT_0x2F
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    mov  r24,r26
    mov  r25,r27
strcpyf0:
	lpm
    adiw r30,1
    st   x+,r0
    tst  r0
    brne strcpyf0
    mov  r30,r24
    mov  r31,r25
    ret

	.CSEG
_ftrunc:
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x3C
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x3C
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET

	.DSEG
_Keypad:
	.BYTE 0x10
_numA:
	.BYTE 0x4
_numB:
	.BYTE 0x4
_numC:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4
__base_y_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	CLR  R4
	CLR  R5
	LDI  R30,LOW(255)
	MOV  R6,R30
	MOV  R7,R30
	CLR  R8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	STS  _numA,R30
	STS  _numA+1,R30
	STS  _numA+2,R30
	STS  _numA+3,R30
	STS  _numB,R30
	STS  _numB+1,R30
	STS  _numB+2,R30
	STS  _numB+3,R30
	STS  _numC,R30
	STS  _numC+1,R30
	STS  _numC+2,R30
	STS  _numC+3,R30
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(255)
	CP   R30,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(255)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDD  R26,Y+39
	CPI  R26,LOW(0xA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0xB:
	LDS  R26,_numA
	LDS  R27,_numA+1
	LDS  R24,_numA+2
	LDS  R25,_numA+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xC:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	RCALL __MULF12
	RCALL __MOVED12
	LDD  R30,Y+39
	RCALL SUBOPT_0x3
	RCALL __CWD1
	RCALL __CDF1
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0xE:
	STS  _numA,R30
	STS  _numA+1,R31
	STS  _numA+2,R22
	STS  _numA+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0xF:
	LDS  R30,_numA
	LDS  R31,_numA+1
	LDS  R22,_numA+2
	LDS  R23,_numA+3
	RCALL __PUTPARD1
	ST   -Y,R17
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,12
	RCALL _ftoa
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,7
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	__GETD2S 3
	RCALL SUBOPT_0xC
	RCALL __DIVF21
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__GETD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x13:
	LDS  R30,_numA
	LDS  R31,_numA+1
	LDS  R22,_numA+2
	LDS  R23,_numA+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x14:
	RCALL __PUTPARD1
	ST   -Y,R17
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,12
	RJMP _ftoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(1)
	MOV  R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(15)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	RCALL _lcd_putchar
	LDI  R30,LOW(11)
	MOV  R4,R30
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	RCALL _lcd_putchar
	LDI  R30,LOW(12)
	MOV  R4,R30
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL _lcd_putchar
	LDI  R30,LOW(13)
	MOV  R4,R30
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	RCALL _lcd_putchar
	LDI  R30,LOW(14)
	MOV  R4,R30
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(61)
	RCALL _lcd_putchar
	LDI  R30,LOW(2)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x13
	STS  _numC,R30
	STS  _numC+1,R31
	STS  _numC+2,R22
	STS  _numC+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x1D:
	LDS  R30,_numC
	LDS  R31,_numC+1
	LDS  R22,_numC+2
	LDS  R23,_numC+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1E:
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,7
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1F:
	LDS  R26,_numB
	LDS  R27,_numB+1
	LDS  R24,_numB+2
	LDS  R25,_numB+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	STS  _numB,R30
	STS  _numB+1,R31
	STS  _numB+2,R22
	STS  _numB+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	LDS  R30,_numB
	LDS  R31,_numB+1
	LDS  R22,_numB+2
	LDS  R23,_numB+3
	RCALL __PUTPARD1
	ST   -Y,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x22:
	MOV  R26,R28
	MOV  R27,R29
	ADIW R26,12
	RJMP _ftoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	MOV  R26,R4
	RCALL _caculate
	RCALL _lcd_clear
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
	RCALL SUBOPT_0x1D
	RCALL __PUTPARD1
	ST   -Y,R8
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	STS  _numB,R30
	STS  _numB+1,R30
	STS  _numB+2,R30
	STS  _numB+3,R30
	CLR  R7
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0xE
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x26:
	RCALL _lcd_putchar
	LDI  R30,LOW(1)
	MOV  R5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	RCALL SUBOPT_0x1D
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(255)
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x29:
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STS  _numB,R30
	STS  _numB+1,R30
	STS  _numB+2,R30
	STS  _numB+3,R30
	STS  _numC,R30
	STS  _numC+1,R30
	STS  _numC+2,R30
	STS  _numC+3,R30
	RCALL _lcd_clear
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2A:
	MOV  R4,R30
	LDI  R30,LOW(1)
	MOV  R5,R30
	MOV  R6,R8
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	MOV  R17,R8
	CLR  R8
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	MOV  R30,R6
	SUBI R30,LOW(1)
	MOV  R8,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2D:
	LDS  R30,_numB
	LDS  R31,_numB+1
	LDS  R22,_numB+2
	LDS  R23,_numB+3
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x2E:
	STS  _numC,R30
	STS  _numC+1,R31
	STS  _numC+2,R22
	STS  _numC+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x30:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x32:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x33:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x35:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x36:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x39:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3B:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G102
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL __GETD1S0
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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R18
	MOV  R31,R19
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MOVED12:
	MOV  R26,R30
	MOV  R27,R31
	MOV  R24,R22
	MOV  R25,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
