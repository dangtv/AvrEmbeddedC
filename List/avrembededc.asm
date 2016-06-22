
;CodeVisionAVR C Compiler V3.24 Evaluation
;(C) Copyright 1998-2015 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 4.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 1
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU GICR=0x3B
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
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
	MOVW R26,R28
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
	MOVW R26,R28
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _kytu=R6
	.DEF _b=R9
	.DEF _received_byte=R8
	.DEF _isComplete=R10
	.DEF _isComplete_msb=R11
	.DEF _package_size=R12
	.DEF _package_size_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x2
	.DB  0x1,0x0,0x0,0x0

_0xA0004:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0xA0018:
	.DB  0x1E,0xF,0xA,0x5,0xC,0x5,0x10,0x1
	.DB  0x1
_0xA0000:
	.DB  0x20,0x4E,0x68,0x69,0x65,0x74,0x20,0x64
	.DB  0x6F,0x20,0x68,0x69,0x65,0x6E,0x20,0x74
	.DB  0x61,0x69,0x20,0x6C,0x61,0x20,0x25,0x64
	.DB  0x20,0x6F,0x43,0xA,0xD,0x0,0x20,0x47
	.DB  0x69,0x6F,0x20,0x68,0x69,0x65,0x6E,0x20
	.DB  0x74,0x61,0x69,0x20,0x6C,0x61,0x20,0x25
	.DB  0x64,0x3A,0x25,0x64,0x3A,0x25,0x64,0xA
	.DB  0xD,0x0,0x4E,0x68,0x69,0x65,0x74,0x20
	.DB  0x64,0x6F,0x20,0x68,0x69,0x65,0x6E,0x20
	.DB  0x74,0x61,0x69,0x20,0x6C,0x61,0x20,0x25
	.DB  0x66,0x0,0x78,0x69,0x6E,0x20,0x63,0x68
	.DB  0x61,0x6F,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _ma
	.DW  _0xA0004*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
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
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;#include <myds18b20ver1.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// the following arrays specify the addresses of *my* ds18b20 devices
;// substitute the address of your devices before using.
;
;//byte rom0[] = {0x28, 0xE1, 0x21, 0xA3, 0x02, 0x00, 0x00, 0x5B};
;//byte rom1[] = {0x28, 0x1B, 0x21, 0x30, 0x05, 0x00, 0x00, 0xF5};
;
;byte therm_Reset() {
; 0000 0009 byte therm_Reset() {

	.CSEG
; 0000 000A     byte i;
; 0000 000B     THERM_OUTPUT(); // set pin as output
;	i -> R17
; 0000 000C     THERM_LOW(); // pull pin low for 480uS
; 0000 000D     delay_us(480);
; 0000 000E     THERM_INPUT(); // set pin as input
; 0000 000F     delay_us(60); // wait for 60uS
; 0000 0010     i = THERM_READ(); // get pin value
; 0000 0011     delay_us(420); // wait for rest of 480uS period
; 0000 0012     return i;
; 0000 0013 }
;
;void therm_WriteBit(byte _bit) {
; 0000 0015 void therm_WriteBit(byte _bit) {
; 0000 0016     THERM_OUTPUT(); // set pin as output
;	_bit -> Y+0
; 0000 0017     THERM_LOW(); // pull pin low for 1uS
; 0000 0018     delay_us(1);
; 0000 0019     if (_bit) THERM_INPUT(); // to write 1, float pin
; 0000 001A     delay_us(60);
; 0000 001B     THERM_INPUT(); // wait 60uS & release pin
; 0000 001C }
;
;byte therm_ReadBit() {
; 0000 001E byte therm_ReadBit() {
; 0000 001F     byte _bit = 0;
; 0000 0020     THERM_OUTPUT(); // set pin as output
;	_bit -> R17
; 0000 0021     THERM_LOW(); // pull pin low for 1uS
; 0000 0022     delay_us(1);
; 0000 0023     THERM_INPUT(); // release pin & wait 14 uS
; 0000 0024     delay_us(14);
; 0000 0025     if (THERM_READ()) _bit = 1; // read pin value
; 0000 0026     delay_us(45); // wait rest of 60uS period
; 0000 0027     return _bit;
; 0000 0028 }
;
;void therm_WriteByte(byte data) {
; 0000 002A void therm_WriteByte(byte data) {
; 0000 002B     byte i = 8;
; 0000 002C     while (i--) // for 8 bits:
;	data -> Y+1
;	i -> R17
; 0000 002D     {
; 0000 002E         therm_WriteBit(data & 1); // send least significant bit
; 0000 002F         data >>= 1; // shift all bits right
; 0000 0030     }
; 0000 0031 }
;
;byte therm_ReadByte() {
; 0000 0033 byte therm_ReadByte() {
; 0000 0034     byte i = 8, data = 0;
; 0000 0035     while (i--) // for 8 bits:
;	i -> R17
;	data -> R16
; 0000 0036     {
; 0000 0037         data >>= 1; // shift all bits right
; 0000 0038         data |= (therm_ReadBit() << 7); // get next bit (LSB first)
; 0000 0039     }
; 0000 003A     return data;
; 0000 003B }
;
;//void therm_MatchRom(byte rom[]) {
;//    byte i;
;//    therm_WriteByte(THERM_MATCHROM);
;//    for (i = 0; i < 8; i++)
;//        therm_WriteByte(rom[i]);
;//}
;
;void therm_ReadTempRaw(byte id[], byte *t0, byte *t1)
; 0000 0045 // Returns the two temperature bytes from the scratchpad
; 0000 0046 {
; 0000 0047 //    therm_Reset(); // skip ROM & start temp conversion
; 0000 0048 
; 0000 0049     //    if (id) therm_MatchRom(id);
; 0000 004A     //    else therm_WriteByte(THERM_SKIPROM);
; 0000 004B     //    therm_WriteByte(THERM_CONVERTTEMP);
; 0000 004C     //    while (!therm_ReadBit()); // wait until conversion completed
; 0000 004D     //    therm_Reset(); // read first two bytes from scratchpad
; 0000 004E     //    if (id) therm_MatchRom(id);
; 0000 004F     //    else therm_WriteByte(THERM_SKIPROM);
; 0000 0050 
; 0000 0051     therm_Reset(); // skip ROM & start temp conversion
;	id -> Y+4
;	*t0 -> Y+2
;	*t1 -> Y+0
; 0000 0052     therm_WriteByte(THERM_SKIPROM);
; 0000 0053     therm_WriteByte(THERM_CONVERTTEMP);
; 0000 0054     while (!therm_ReadBit()); // wait until conversion completed
; 0000 0055 
; 0000 0056     therm_Reset(); // read first two bytes from scratchpad
; 0000 0057     therm_WriteByte(THERM_SKIPROM);
; 0000 0058 
; 0000 0059     therm_WriteByte(THERM_READSCRATCH);
; 0000 005A     *t0 = therm_ReadByte(); // first byte
; 0000 005B     *t1 = therm_ReadByte(); // second byte
; 0000 005C }
;
;void therm_ReadTempC(byte id[], int *whole, int *decimal)
; 0000 005F // returns temperature in Celsius as WW.DDDD, where W=whole & D=decimal
; 0000 0060 {
; 0000 0061     byte t0, t1;
; 0000 0062     therm_ReadTempRaw(id, &t0, &t1); // get temperature values
;	id -> Y+6
;	*whole -> Y+4
;	*decimal -> Y+2
;	t0 -> R17
;	t1 -> R16
; 0000 0063     *whole = (t1 & 0x07) << 4; // grab lower 3 bits of t1
; 0000 0064     *whole |= t0 >> 4; // and upper 4 bits of t0
; 0000 0065     *decimal = t0 & 0x0F; // decimals in lower 4 bits of t0
; 0000 0066     *decimal *= 625; // conversion factor for 12-bit resolution
; 0000 0067 }
;
;void therm_ReadTempF(byte id[], int *whole, int *decimal)
; 0000 006A // returns temperature in Fahrenheit as WW.D, where W=whole & D=decimal
; 0000 006B {
; 0000 006C     byte t0, t1;
; 0000 006D     int t16, t2, f10;
; 0000 006E     therm_ReadTempRaw(id, &t0, &t1); // get temperature values
;	id -> Y+12
;	*whole -> Y+10
;	*decimal -> Y+8
;	t0 -> R17
;	t1 -> R16
;	t16 -> R18,R19
;	t2 -> R20,R21
;	f10 -> Y+6
; 0000 006F     t16 = (t1 << 8) + t0; // result is temp*16, in celcius
; 0000 0070     t2 = t16 / 8; // get t*2, with fractional part lost
; 0000 0071     f10 = t16 + t2 + 320; // F=1.8C+32, so 10F = 18C+320 = 16C + 2C + 320
; 0000 0072     *whole = f10 / 10; // get whole part
; 0000 0073     *decimal = f10 % 10; // get fractional part
; 0000 0074 }
;
;//inline __attribute__((gnu_inline)) void quickDelay(int delay)
;//// this routine will pause 0.25uS per delay unit
;//// for testing only; use _us_Delay() routine for >1uS delays
;//{
;//    while (delay--) // uses sbiw to subtract 1 from 16bit word
;//        asm volatile("nop"); // nop, sbiw, brne = 4 cycles = 0.25 uS
;//}
;
;// ---------------------------------------------------------------------------
;// ROM READER PROGRAM
;
;byte RomReaderProgram()
; 0000 0082 // Read the ID of the attached Dallas 18B20 device
; 0000 0083 // Note: only ONE device should be on the bus.
; 0000 0084 {
; 0000 0085     byte i;
; 0000 0086     byte data;
; 0000 0087     //    LCD_String("ID (ROM) Reader:");
; 0000 0088 //    while (1) {
; 0000 0089         //        LCD_Line(1);
; 0000 008A         // write 64-bit ROM code on first LCD line
; 0000 008B         therm_Reset();
;	i -> R17
;	data -> R16
; 0000 008C         therm_WriteByte(THERM_READROM);
; 0000 008D //        for (i = 0; i < 8; i++) {
; 0000 008E             data = therm_ReadByte();
; 0000 008F             //            LCD_HexByte(data);
; 0000 0090 //        }
; 0000 0091         //        msDelay(1000); // do a read every second
; 0000 0092 //    }
; 0000 0093         return data;
; 0000 0094 }
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#include <myds18b20ver2.h>
;
;/*
; * ds18b20 init
; */
;uint8_t ds18b20_reset(void) {
; 0001 000A uint8_t ds18b20_reset(void) {

	.CSEG
_ds18b20_reset:
; .FSTART _ds18b20_reset
; 0001 000B 	uint8_t i;
; 0001 000C 
; 0001 000D 	//low for 480us
; 0001 000E 	DS18B20_PORT &= ~ (1<<DS18B20_DQ); //low
	ST   -Y,R17
;	i -> R17
	CBI  0x18,0
; 0001 000F 	DS18B20_DDR |= (1<<DS18B20_DQ); //output
	SBI  0x17,0
; 0001 0010 	delay_us(480);
	__DELAY_USW 480
; 0001 0011 
; 0001 0012 	//release line and wait for 60uS
; 0001 0013 	DS18B20_DDR &= ~(1<<DS18B20_DQ); //input
	CBI  0x17,0
; 0001 0014 	delay_us(60);
	__DELAY_USB 80
; 0001 0015 
; 0001 0016 	//get value and wait 420us
; 0001 0017 	i = (DS18B20_PIN & (1<<DS18B20_DQ));
	IN   R30,0x16
	ANDI R30,LOW(0x1)
	MOV  R17,R30
; 0001 0018 	delay_us(420);
	__DELAY_USW 420
; 0001 0019 
; 0001 001A 	//return the read value, 0=ok, 1=error
; 0001 001B 	return i;
	RJMP _0x20A0003
; 0001 001C }
; .FEND
;
;/*
; * write one bit
; */
;void ds18b20_writebit(uint8_t _bit){
; 0001 0021 void ds18b20_writebit(uint8_t _bit){
_ds18b20_writebit:
; .FSTART _ds18b20_writebit
; 0001 0022 	//low for 1uS
; 0001 0023 	DS18B20_PORT &= ~ (1<<DS18B20_DQ); //low
	ST   -Y,R26
;	_bit -> Y+0
	RCALL SUBOPT_0x0
; 0001 0024 	DS18B20_DDR |= (1<<DS18B20_DQ); //output
; 0001 0025 	delay_us(1);
; 0001 0026 
; 0001 0027 	//if we want to write 1, release the line (if not will keep low)
; 0001 0028 	if(_bit)
	LD   R30,Y
	CPI  R30,0
	BREQ _0x20003
; 0001 0029 		DS18B20_DDR &= ~(1<<DS18B20_DQ); //input
	CBI  0x17,0
; 0001 002A 
; 0001 002B 	//wait 60uS and release the line
; 0001 002C 	delay_us(60);
_0x20003:
	__DELAY_USB 80
; 0001 002D 	DS18B20_DDR &= ~(1<<DS18B20_DQ); //input
	CBI  0x17,0
; 0001 002E }
	JMP  _0x20A0002
; .FEND
;
;/*
; * read one bit
; */
;uint8_t ds18b20_readbit(void){
; 0001 0033 uint8_t ds18b20_readbit(void){
_ds18b20_readbit:
; .FSTART _ds18b20_readbit
; 0001 0034 	uint8_t _bit=0;
; 0001 0035 
; 0001 0036 	//low for 1uS
; 0001 0037 	DS18B20_PORT &= ~ (1<<DS18B20_DQ); //low
	ST   -Y,R17
;	_bit -> R17
	LDI  R17,0
	RCALL SUBOPT_0x0
; 0001 0038 	DS18B20_DDR |= (1<<DS18B20_DQ); //output
; 0001 0039 	delay_us(1);
; 0001 003A 
; 0001 003B 	//release line and wait for 14uS
; 0001 003C 	DS18B20_DDR &= ~(1<<DS18B20_DQ); //input
	CBI  0x17,0
; 0001 003D 	delay_us(14);
	__DELAY_USB 19
; 0001 003E 
; 0001 003F 	//read the value
; 0001 0040 	if(DS18B20_PIN & (1<<DS18B20_DQ))
	SBIC 0x16,0
; 0001 0041 		_bit=1;
	LDI  R17,LOW(1)
; 0001 0042 
; 0001 0043 	//wait 45uS and return read value
; 0001 0044 	delay_us(45);
	__DELAY_USB 60
; 0001 0045 	return _bit;
_0x20A0003:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0001 0046 }
; .FEND
;
;/*
; * write one byte
; */
;void ds18b20_writebyte(uint8_t _byte){
; 0001 004B void ds18b20_writebyte(uint8_t _byte){
_ds18b20_writebyte:
; .FSTART _ds18b20_writebyte
; 0001 004C 	uint8_t i=8;
; 0001 004D 	while(i--){
	ST   -Y,R26
	ST   -Y,R17
;	_byte -> Y+1
;	i -> R17
	LDI  R17,8
_0x20005:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x20007
; 0001 004E 		ds18b20_writebit(_byte&1);
	LDD  R30,Y+1
	ANDI R30,LOW(0x1)
	MOV  R26,R30
	RCALL _ds18b20_writebit
; 0001 004F 		_byte >>= 1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
; 0001 0050 	}
	RJMP _0x20005
_0x20007:
; 0001 0051 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
;
;/*
; * read one byte
; */
;uint8_t ds18b20_readbyte(void){
; 0001 0056 uint8_t ds18b20_readbyte(void){
_ds18b20_readbyte:
; .FSTART _ds18b20_readbyte
; 0001 0057 	uint8_t i=8, n=0;
; 0001 0058 	while(i--){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	n -> R16
	LDI  R17,8
	LDI  R16,0
_0x20008:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000A
; 0001 0059 		n >>= 1;
	LSR  R16
; 0001 005A 		n |= (ds18b20_readbit()<<7);
	RCALL _ds18b20_readbit
	ROR  R30
	LDI  R30,0
	ROR  R30
	OR   R16,R30
; 0001 005B 	}
	RJMP _0x20008
_0x2000A:
; 0001 005C 	return n;
	MOV  R30,R16
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 005D }
; .FEND
;
;/*
; * get temperature in celsius
; */
;double ds18b20_gettemp(void) {
; 0001 0062 double ds18b20_gettemp(void) {
_ds18b20_gettemp:
; .FSTART _ds18b20_gettemp
; 0001 0063 	uint8_t temperature[2];
; 0001 0064 	int8_t digit;
; 0001 0065 	uint16_t decimal;
; 0001 0066 	double retd = 0;
; 0001 0067 
; 0001 0068 	ds18b20_reset(); //reset
	SBIW R28,6
	RCALL SUBOPT_0x1
	RCALL __SAVELOCR4
;	temperature -> Y+8
;	digit -> R17
;	decimal -> R18,R19
;	retd -> Y+4
	RCALL _ds18b20_reset
; 0001 0069 	ds18b20_writebyte(DS18B20_CMD_SKIPROM); //skip ROM
	LDI  R26,LOW(204)
	RCALL _ds18b20_writebyte
; 0001 006A 	ds18b20_writebyte(DS18B20_CMD_CONVERTTEMP); //start temperature conversion
	LDI  R26,LOW(68)
	RCALL _ds18b20_writebyte
; 0001 006B 
; 0001 006C 	while(!ds18b20_readbit()); //wait until conversion is complete
_0x2000B:
	RCALL _ds18b20_readbit
	CPI  R30,0
	BREQ _0x2000B
; 0001 006D 
; 0001 006E 	ds18b20_reset(); //reset
	RCALL _ds18b20_reset
; 0001 006F 	ds18b20_writebyte(DS18B20_CMD_SKIPROM); //skip ROM
	LDI  R26,LOW(204)
	RCALL _ds18b20_writebyte
; 0001 0070 	ds18b20_writebyte(DS18B20_CMD_RSCRATCHPAD); //read scratchpad
	LDI  R26,LOW(190)
	RCALL _ds18b20_writebyte
; 0001 0071 
; 0001 0072 	//read 2 byte from scratchpad
; 0001 0073 	temperature[0] = ds18b20_readbyte();
	RCALL _ds18b20_readbyte
	STD  Y+8,R30
; 0001 0074 	temperature[1] = ds18b20_readbyte();
	RCALL _ds18b20_readbyte
	STD  Y+9,R30
; 0001 0075 
; 0001 0076 	ds18b20_reset(); //reset
	RCALL _ds18b20_reset
; 0001 0077 
; 0001 0078 	//store temperature integer digits
; 0001 0079 	digit = temperature[0]>>4;
	LDD  R30,Y+8
	SWAP R30
	ANDI R30,0xF
	MOV  R17,R30
; 0001 007A 	digit |= (temperature[1]&0x7)<<4;
	LDD  R30,Y+9
	ANDI R30,LOW(0x7)
	SWAP R30
	ANDI R30,0xF0
	OR   R17,R30
; 0001 007B 
; 0001 007C 	//store temperature decimal digits
; 0001 007D 	decimal = temperature[0]&0xf;
	LDD  R30,Y+8
	LDI  R31,0
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	MOVW R18,R30
; 0001 007E 	decimal *= DS18B20_DECIMALSTEPS;
	LDI  R26,LOW(625)
	LDI  R27,HIGH(625)
	RCALL __MULW12U
	MOVW R18,R30
; 0001 007F 
; 0001 0080 	//compose the double temperature value and return it
; 0001 0081 	retd = digit + decimal * 0.0001;
	MOV  R30,R17
	LDI  R31,0
	SBRC R30,7
	SER  R31
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x38D1B717
	RCALL __MULF12
	POP  R26
	POP  R27
	RCALL __CWD2
	RCALL __CDF2
	RCALL __ADDF12
	__PUTD1S 4
; 0001 0082 
; 0001 0083 	return retd;
	RCALL __LOADLOCR4
	ADIW R28,10
	RET
; 0001 0084 }
; .FEND
;#include <myds1307rtc.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;//Khoi dong TWI
;unsigned char registry_ds1307[7]; // mang de luu tam cac gia tri doc duoc tu thanh ghi cua ds1307
;
;void TWI_Init(void) {
; 0002 0006 void TWI_Init(void) {

	.CSEG
; 0002 0007     TWSR = 0x00; //Prescaler=1
; 0002 0008     TWBR = _100K;
; 0002 0009     TWCR = (1 << TWINT) | (1 << TWEN);
; 0002 000A }
;
;///chon dia chi thanh ghi can thao tac, dummy write
;//Addr: dia thi thanh ghi can ghi
;
;unsigned char TWI_DS1307_wadr(unsigned char Addr) {
; 0002 000F unsigned char TWI_DS1307_wadr(unsigned char Addr) {
; 0002 0010 
; 0002 0011     TWCR = TWI_START; //goi START condition
;	Addr -> Y+0
; 0002 0012     while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 0013     if ((TWSR & 0xF8) != 0x08) return TWSR; //neu goi Start co loi thi thoat
; 0002 0014 
; 0002 0015     TWDR = (DS1307_SLA << 1) + TWI_W; //dia chi DS va bit W
; 0002 0016     TWCR = TWI_Clear_TWINT; //xoa TWINT, bat dau goi SLA
; 0002 0017     while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 0018     if ((TWSR & 0xF8) != 0x18) return TWSR; //device address send error, escape anyway
; 0002 0019 
; 0002 001A     TWDR = Addr; //goi dia chi thanh ghi can ghi vao
; 0002 001B     TWCR = TWI_Clear_TWINT; //start send address by cleaning TWINT
; 0002 001C     while ((TWCR & 0x80) == 0x00); //check and wait for TWINT bit=1
; 0002 001D     if ((TWSR & 0xF8) != 0x28) return TWSR; //neu du lieu goi ko thanh cong thi thoat
; 0002 001E 
; 0002 001F     TWCR = TWI_STOP; //STOP condition
; 0002 0020     return 0;
; 0002 0021 }
;
;//ghi 1 mang dat vao DS
;//Addr: dia thi thanh ghi can ghi
;//Data[]: mang du lieu
;//len: so luong byte can ghi
;
;unsigned char TWI_DS1307_wblock(unsigned char Addr, unsigned char Data[], unsigned char len) {
; 0002 0028 unsigned char TWI_DS1307_wblock(unsigned char Addr, unsigned char Data[], unsigned char len) {
; 0002 0029     unsigned char i = 0;
; 0002 002A     TWCR = TWI_START; //goi START condition
;	Addr -> Y+4
;	Data -> Y+2
;	len -> Y+1
;	i -> R17
; 0002 002B     while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 002C     if ((TWSR & 0xF8) != 0x08) return TWSR; //neu goi Start co loi thi thoat
; 0002 002D 
; 0002 002E     TWDR = (DS1307_SLA << 1) + TWI_W; //dia chi DS va bit W
; 0002 002F     TWCR = TWI_Clear_TWINT; //xoa TWINT de bat dau goi
; 0002 0030     while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 0031     if ((TWSR & 0xF8) != 0x18) return TWSR; //neu co loi truyen SLA, thoat
; 0002 0032 
; 0002 0033     TWDR = Addr; //goi dia chi thanh ghi can ghi vao
; 0002 0034     TWCR = TWI_Clear_TWINT; //xoa TWINT de bat dau goi
; 0002 0035     while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 0036     if ((TWSR & 0xF8) != 0x28) return TWSR;
; 0002 0037 
; 0002 0038     for (i = 0; i < len; i++) {
; 0002 0039         TWDR = Data[i]; //chuan bi xuat du lieu
; 0002 003A         TWCR = TWI_Clear_TWINT; //xoa TWINT, bat dau send
; 0002 003B         while ((TWCR & 0x80) == 0x00); //cho TWINT bit=1
; 0002 003C         if ((TWSR & 0xF8) != 0x28) return TWSR; //neu status ko phai la 0x28 thi return
; 0002 003D     }
; 0002 003E 
; 0002 003F     TWCR = TWI_STOP; //STOP condition
; 0002 0040     return 0;
; 0002 0041 }
;
;//doc 1 mang tu DS
;
;unsigned char TWI_DS1307_rblock(unsigned char Data[], unsigned char len) {
; 0002 0045 unsigned char TWI_DS1307_rblock(unsigned char Data[], unsigned char len) {
; 0002 0046     unsigned char i;
; 0002 0047 
; 0002 0048     TWCR = TWI_START; // Start--------------------------------------------------------------------
;	Data -> Y+2
;	len -> Y+1
;	i -> R17
; 0002 0049     while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x08)); //cho TWINT bit=1 va goi START thanh cong
; 0002 004A 
; 0002 004B     TWDR = (DS1307_SLA << 1) + TWI_R; //goi dia chi SLA +READ
; 0002 004C     TWCR = TWI_Clear_TWINT; //bat dau, xoa TWINT
; 0002 004D     while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x40)); //cho TWINT bit=1	va goi SLA thanh cong
; 0002 004E 
; 0002 004F     //nhan len-1 bytes dau tien---------------------
; 0002 0050     for (i = 0; i < len - 1; i++) {
; 0002 0051         TWCR = TWI_Read_ACK; //xoa TWINT,se goi ACK sau khi nhan moi byte
; 0002 0052         while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x50)); //cho TWINT bit=1 hoac nhan duoc ACK
; 0002 0053         Data[i] = TWDR; //doc du lieu vao mang Data
; 0002 0054     }
; 0002 0055     //nhan byte cuoi
; 0002 0056     TWCR = TWI_Clear_TWINT; //xoa TWINT de nhan byte cuoi, sau do set NOT ACK
; 0002 0057     while (((TWCR & 0x80) == 0x00) || ((TWSR & 0xF8) != 0x58)); //cho TWIN=1 hoac trang thai not ack
; 0002 0058     Data[len - 1] = TWDR;
; 0002 0059 
; 0002 005A     TWCR = TWI_STOP; //STOP condition
; 0002 005B     return 0;
; 0002 005C }
;
;//----------------------------------------------------------------------------
;// xay dung lai cac ham ma khong dung thu vien
;
;// doi BCD sang thap phan va nguoc lai------------
;
;unsigned char BCD2Dec(unsigned char BCD) {
; 0002 0063 unsigned char BCD2Dec(unsigned char BCD) {
; 0002 0064     unsigned char L, H;
; 0002 0065     L = BCD & 0x0F;
;	BCD -> Y+2
;	L -> R17
;	H -> R16
; 0002 0066     H = (BCD >> 4)*10;
; 0002 0067     return (H + L);
; 0002 0068 }
;
;unsigned char Dec2BCD(unsigned char Dec) {
; 0002 006A unsigned char Dec2BCD(unsigned char Dec) {
; 0002 006B     unsigned char L, H;
; 0002 006C     L = Dec % 10;
;	Dec -> Y+2
;	L -> R17
;	H -> R16
; 0002 006D     H = (Dec / 10) << 4;
; 0002 006E     return (H + L);
; 0002 006F }
;
;Time myGetTimeFromDS1307() {
; 0002 0071 Time myGetTimeFromDS1307() {
; 0002 0072     Time time;
; 0002 0073     time.Hour = 10;
;	time -> Y+0
; 0002 0074     time.Minute = 15;
; 0002 0075     //    return time;
; 0002 0076     TWI_DS1307_wadr(0x00); //set dia chi ve 0
; 0002 0077     delay_ms(1); //cho DS1307 xu li
; 0002 0078     TWI_DS1307_rblock(registry_ds1307, 7); //doc ca khoi thoi gian (7 bytes)
; 0002 0079 
; 0002 007A     time.Second = BCD2Dec(registry_ds1307[0] & 0x7F);
; 0002 007B     time.Minute = BCD2Dec(registry_ds1307[1]);
; 0002 007C     // mode lay tu bit 6 ( =0 la 24h; =1 la 12h)
; 0002 007D     // mode = 0 la 24h, =1 la 12h
; 0002 007E     time.Mode = ((registry_ds1307[2] & 0x40) != 0);
; 0002 007F     // AM hay PM lay tu bit 5
; 0002 0080     time.AP = ((registry_ds1307[2] & 0x20) != 0);
; 0002 0081     if (time.Mode != 0) time.Hour = BCD2Dec(registry_ds1307[2] & 0x1F); //mode 12h
; 0002 0082     else time.Hour = BCD2Dec(registry_ds1307[2] & 0x3F); //mode 24h
; 0002 0083     time.Date = BCD2Dec(registry_ds1307[4]);
; 0002 0084     time.Month = BCD2Dec(registry_ds1307[5]);
; 0002 0085     time.Year = BCD2Dec(registry_ds1307[6]);
; 0002 0086     return time;
; 0002 0087 }
;
;void mySetTimeForDS1307(Time * t) {
; 0002 0089 void mySetTimeForDS1307(Time * t) {
; 0002 008A     registry_ds1307[0] = Dec2BCD(t->Second);
;	*t -> Y+0
; 0002 008B 
; 0002 008C     registry_ds1307[1] = Dec2BCD(t->Minute);
; 0002 008D     if (t->Mode != 0) // che do hien thi 12h
; 0002 008E         // bit 7 = 0; bit 6 =1;(che do 12h), 0: che do 24h
; 0002 008F         //; bit 5 =0 -> AM, 1->PM
; 0002 0090         //5bit con lai la ma BCD cua gio
; 0002 0091         registry_ds1307[2] = Dec2BCD(t->Hour) | (t->Mode << 6) | (t->AP << 5); //mode 12h
; 0002 0092 
; 0002 0093     else
; 0002 0094         // bit 7 = 0; bit 6 =0;(che do 24h) ;
; 0002 0095         registry_ds1307[2] = Dec2BCD(t->Hour); //mode 24h
; 0002 0096 
; 0002 0097     registry_ds1307[4] = Dec2BCD(t->Date);
; 0002 0098     registry_ds1307[5] = Dec2BCD(t->Month);
; 0002 0099     registry_ds1307[6] = Dec2BCD(t->Year);
; 0002 009A 
; 0002 009B 
; 0002 009C     TWI_DS1307_wblock(0x00, registry_ds1307, 7); //doc ca khoi thoi gian (7 bytes)
; 0002 009D     delay_ms(1); //cho DS1307 xu li
; 0002 009E }
;// ---------------------------------------------------------------------------
;// I2C (TWI) ROUTINES
;//
;// On the AVRmega series, PA4 is the data line (SDA) and PA5 is the clock (SCL
;// The standard clock rate is 100 KHz, and set by I2C_Init. It depends on the AVR osc. freq.
;#include <myds1307rtcver2.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;
;
;
;//void DS1307_GetTime(byte *hours, byte *minutes, byte *seconds)
;//// returns hours, minutes, and seconds in BCD format
;//{
;//    *hours = I2C_ReadRegister(DS1307, HOURS_REGISTER);
;//    *minutes = I2C_ReadRegister(DS1307, MINUTES_REGISTER);
;//    *seconds = I2C_ReadRegister(DS1307, SECONDS_REGISTER);
;//    if (*hours & 0x40) // 12hr mode:
;//        *hours &= 0x1F; // use bottom 5 bits (pm bit = temp & 0x20)
;//    else *hours &= 0x3F; // 24hr mode: use bottom 6 bits
;//}
;//
;//void DS1307_GetDate(byte *months, byte *days, byte *years)
;//// returns months, days, and years in BCD format
;//{
;//    *months = I2C_ReadRegister(DS1307, MONTHS_REGISTER);
;//    *days = I2C_ReadRegister(DS1307, DAYS_REGISTER);
;//    *years = I2C_ReadRegister(DS1307, YEARS_REGISTER);
;//}
;//
;//void SetTimeDate()
;//// simple, hard-coded way to set the date.
;//{
;//    I2C_WriteRegister(DS1307, MONTHS_REGISTER, 0x08);
;//    I2C_WriteRegister(DS1307, DAYS_REGISTER, 0x31);
;//    I2C_WriteRegister(DS1307, YEARS_REGISTER, 0x13);
;//    I2C_WriteRegister(DS1307, HOURS_REGISTER, 0x08 + 0x40); // add 0x40 for PM
;//    I2C_WriteRegister(DS1307, MINUTES_REGISTER, 0x51);
;//    I2C_WriteRegister(DS1307, SECONDS_REGISTER, 0x00);
;//}
;
;
;unsigned char BCD2Decver2(unsigned char BCD) {
; 0003 002A unsigned char BCD2Decver2(unsigned char BCD) {

	.CSEG
_BCD2Decver2:
; .FSTART _BCD2Decver2
; 0003 002B     unsigned char L, H;
; 0003 002C     L = BCD & 0x0F;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	BCD -> Y+2
;	L -> R17
;	H -> R16
	LDD  R30,Y+2
	ANDI R30,LOW(0xF)
	MOV  R17,R30
; 0003 002D     H = (BCD >> 4)*10;
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,0xF
	LDI  R26,LOW(10)
	MULS R30,R26
	MOV  R16,R0
; 0003 002E     return (H + L);
	MOV  R30,R17
	ADD  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x20A0001
; 0003 002F }
; .FEND
;
;unsigned char Dec2BCDver2(unsigned char Dec) {
; 0003 0031 unsigned char Dec2BCDver2(unsigned char Dec) {
; 0003 0032     unsigned char L, H;
; 0003 0033     L = Dec % 10;
;	Dec -> Y+2
;	L -> R17
;	H -> R16
; 0003 0034     H = (Dec / 10) << 4;
; 0003 0035     return (H + L);
; 0003 0036 }
;
;Time myGetTimeFromDS1307ver2() {
; 0003 0038 Time myGetTimeFromDS1307ver2() {
_myGetTimeFromDS1307ver2:
; .FSTART _myGetTimeFromDS1307ver2
; 0003 0039     Time time;
; 0003 003A     time.Hour = 10;
	SBIW R28,18
;	time -> Y+0
	LDI  R30,LOW(10)
	STD  Y+2,R30
; 0003 003B     time.Minute = 15;
	LDI  R30,LOW(15)
	STD  Y+1,R30
; 0003 003C     //    return time;
; 0003 003D 
; 0003 003E     time.Second = BCD2Decver2(I2C_ReadRegister(DS1307, SECONDS_REGISTER) & 0x7F);
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _I2C_ReadRegister
	ANDI R30,0x7F
	MOV  R26,R30
	RCALL _BCD2Decver2
	ST   Y,R30
; 0003 003F     time.Minute = BCD2Decver2(I2C_ReadRegister(DS1307, MINUTES_REGISTER));
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _I2C_ReadRegister
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+1,R30
; 0003 0040     // mode lay tu bit 6 ( =0 la 24h; =1 la 12h)
; 0003 0041     // mode = 0 la 24h, =1 la 12h
; 0003 0042     time.Mode = ((I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x40) != 0);
	RCALL SUBOPT_0x2
	ANDI R30,LOW(0x40)
	LDI  R26,LOW(0)
	RCALL __NEB12
	STD  Y+7,R30
; 0003 0043     // AM hay PM lay tu bit 5
; 0003 0044     time.AP = ((I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x20) != 0);
	RCALL SUBOPT_0x2
	ANDI R30,LOW(0x20)
	LDI  R26,LOW(0)
	RCALL __NEB12
	STD  Y+8,R30
; 0003 0045     if (time.Mode != 0) time.Hour = BCD2Decver2(I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x1F); //mode 12h
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x60003
	RCALL SUBOPT_0x2
	ANDI R30,LOW(0x1F)
	RJMP _0x60007
; 0003 0046     else time.Hour = BCD2Decver2(I2C_ReadRegister(DS1307, HOURS_REGISTER) & 0x3F); //mode 24h
_0x60003:
	RCALL SUBOPT_0x2
	ANDI R30,LOW(0x3F)
_0x60007:
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+2,R30
; 0003 0047     time.Day = BCD2Decver2(I2C_ReadRegister(DS1307, DAYOFWK_REGISTER));
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _I2C_ReadRegister
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+3,R30
; 0003 0048     time.Date = BCD2Decver2(I2C_ReadRegister(DS1307, DAYS_REGISTER));
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(4)
	RCALL _I2C_ReadRegister
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+4,R30
; 0003 0049     time.Month = BCD2Decver2(I2C_ReadRegister(DS1307, MONTHS_REGISTER));
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _I2C_ReadRegister
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+5,R30
; 0003 004A     time.Year = BCD2Decver2(I2C_ReadRegister(DS1307, YEARS_REGISTER));
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL _I2C_ReadRegister
	MOV  R26,R30
	RCALL _BCD2Decver2
	STD  Y+6,R30
; 0003 004B     return time;
	MOVW R30,R28
	MOVW R26,R28
	ADIW R26,9
	LDI  R24,9
	RCALL __COPYMML
	MOVW R30,R28
	ADIW R30,9
	LDI  R24,9
	IN   R1,SREG
	CLI
	ADIW R28,18
	RET
; 0003 004C }
; .FEND
;
;void mySetTimeForDS1307ver2(Time * t) {
; 0003 004E void mySetTimeForDS1307ver2(Time * t) {
; 0003 004F     I2C_WriteRegister(DS1307, SECONDS_REGISTER, Dec2BCDver2(t->Second));
;	*t -> Y+0
; 0003 0050 
; 0003 0051     I2C_WriteRegister(DS1307, MINUTES_REGISTER,  Dec2BCDver2(t->Minute));
; 0003 0052     if (t->Mode != 0) // che do hien thi 12h
; 0003 0053         // bit 7 = 0; bit 6 =1;(che do 12h), 0: che do 24h
; 0003 0054         //; bit 5 =0 -> AM, 1->PM
; 0003 0055         //5bit con lai la ma BCD cua gio
; 0003 0056         I2C_WriteRegister(DS1307, HOURS_REGISTER, Dec2BCDver2(t->Hour) | (t->Mode << 6) | (t->AP << 5)); //mode 12h
; 0003 0057 
; 0003 0058     else
; 0003 0059         // bit 7 = 0; bit 6 =0;(che do 24h) ;
; 0003 005A         I2C_WriteRegister(DS1307, HOURS_REGISTER, Dec2BCDver2(t->Hour)); //mode 24h
; 0003 005B 
; 0003 005C     I2C_WriteRegister(DS1307, DAYOFWK_REGISTER, Dec2BCDver2(t->Day));
; 0003 005D     I2C_WriteRegister(DS1307, DAYS_REGISTER, Dec2BCDver2(t->Date));
; 0003 005E     I2C_WriteRegister(DS1307, MONTHS_REGISTER, Dec2BCDver2(t->Month));
; 0003 005F     I2C_WriteRegister(DS1307, YEARS_REGISTER, Dec2BCDver2(t->Year));
; 0003 0060 }
;#include <myi2c.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void I2C_Init()
; 0004 0004 // port mac dinh SCL va SDA cua atmega
; 0004 0005 // at 16 MHz, the SCL frequency will be 16/(16+2(TWBR)), assuming prescalar of 0.
; 0004 0006 // so for 100KHz SCL, TWBR = ((F_CPU/F_SCL)-16)/2 = ((16/0.1)-16)/2 = 144/2 = 72.
; 0004 0007 {

	.CSEG
_I2C_Init:
; .FSTART _I2C_Init
; 0004 0008     TWSR = 0; // set prescalar to zero
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0004 0009     TWBR = ((F_CPU / F_SCL) - 16) / 2; // set SCL frequency in TWI bit register
	LDI  R30,LOW(12)
	OUT  0x0,R30
; 0004 000A }
	RET
; .FEND
;
;byte I2C_Detect(byte addr)
; 0004 000D // look for device at specified address; return 1=found, 0=not found
; 0004 000E {
_I2C_Detect:
; .FSTART _I2C_Detect
; 0004 000F     TWCR = TW_START; // send start condition
	ST   -Y,R26
;	addr -> Y+0
	LDI  R30,LOW(164)
	OUT  0x36,R30
; 0004 0010     while (!TW_READY); // wait
_0x80003:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x80003
; 0004 0011     TWDR = addr; // load device's bus address
	RCALL SUBOPT_0x3
; 0004 0012     TWCR = TW_SEND; // and send it
; 0004 0013     while (!TW_READY); // wait
_0x80006:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x80006
; 0004 0014     return (TW_STATUS == 0x18); // return 1 if found; 0 otherwise
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	LDI  R26,LOW(24)
	RCALL __EQB12
	JMP  _0x20A0002
; 0004 0015 }
; .FEND
;
;byte I2C_FindDevice(byte start)
; 0004 0018 // returns with address of first device found; 0=not found
; 0004 0019 {
; 0004 001A     byte addr;
; 0004 001B     for ( addr = start; addr < 0xFF; addr++) // search all 256 addresses
;	start -> Y+1
;	addr -> R17
; 0004 001C     {
; 0004 001D         if (I2C_Detect(addr)) // I2C detected?
; 0004 001E             return addr; // leave as soon as one is found
; 0004 001F     }
; 0004 0020     return 0; // none detected, so return 0.
; 0004 0021 }
;
;void I2C_Start(byte slaveAddr) {
; 0004 0023 void I2C_Start(byte slaveAddr) {
_I2C_Start:
; .FSTART _I2C_Start
; 0004 0024     I2C_Detect(slaveAddr);
	ST   -Y,R26
;	slaveAddr -> Y+0
	LD   R26,Y
	RCALL _I2C_Detect
; 0004 0025 }
	JMP  _0x20A0002
; .FEND
;
;byte I2C_Write(byte data) // sends a data byte to slave
; 0004 0028 {
_I2C_Write:
; .FSTART _I2C_Write
; 0004 0029     TWDR = data; // load data to be sent
	ST   -Y,R26
;	data -> Y+0
	RCALL SUBOPT_0x3
; 0004 002A     TWCR = TW_SEND; // and send it
; 0004 002B     while (!TW_READY); // wait
_0x8000D:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x8000D
; 0004 002C     return (TW_STATUS != 0x28);
	IN   R30,0x1
	ANDI R30,LOW(0xF8)
	LDI  R26,LOW(40)
	RCALL __NEB12
	JMP  _0x20A0002
; 0004 002D }
; .FEND
;
;byte I2C_ReadACK() // reads a data byte from slave
; 0004 0030 {
; 0004 0031     TWCR = TW_ACK; // ack = will read more data
; 0004 0032     while (!TW_READY); // wait
; 0004 0033     return TWDR;
; 0004 0034     //return (TW_STATUS!=0x28);
; 0004 0035 }
;
;byte I2C_ReadNACK() // reads a data byte from slave
; 0004 0038 {
_I2C_ReadNACK:
; .FSTART _I2C_ReadNACK
; 0004 0039     TWCR = TW_NACK; // nack = not reading more data
	LDI  R30,LOW(132)
	OUT  0x36,R30
; 0004 003A     while (!TW_READY); // wait
_0x80013:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x80013
; 0004 003B     return TWDR;
	IN   R30,0x3
	RET
; 0004 003C     //return (TW_STATUS!=0x28);
; 0004 003D }
; .FEND
;
;void I2C_WriteByte(byte busAddr, byte data) {
; 0004 003F void I2C_WriteByte(byte busAddr, byte data) {
; 0004 0040     I2C_Start(busAddr); // send bus address
;	busAddr -> Y+1
;	data -> Y+0
; 0004 0041     I2C_Write(data); // then send the data byte
; 0004 0042     I2C_Stop();
; 0004 0043 }
;
;void I2C_WriteRegister(byte busAddr, byte deviceRegister, byte data) {
; 0004 0045 void I2C_WriteRegister(byte busAddr, byte deviceRegister, byte data) {
; 0004 0046     I2C_Start(busAddr); // send bus address
;	busAddr -> Y+2
;	deviceRegister -> Y+1
;	data -> Y+0
; 0004 0047     I2C_Write(deviceRegister); // first byte = device register address
; 0004 0048     I2C_Write(data); // second byte = data for device register
; 0004 0049     I2C_Stop();
; 0004 004A }
;
;byte I2C_ReadRegister(byte busAddr, byte deviceRegister) {
; 0004 004C byte I2C_ReadRegister(byte busAddr, byte deviceRegister) {
_I2C_ReadRegister:
; .FSTART _I2C_ReadRegister
; 0004 004D     byte data = 0;
; 0004 004E     I2C_Start(busAddr); // send device address
	ST   -Y,R26
	ST   -Y,R17
;	busAddr -> Y+2
;	deviceRegister -> Y+1
;	data -> R17
	LDI  R17,0
	LDD  R26,Y+2
	RCALL _I2C_Start
; 0004 004F     I2C_Write(deviceRegister); // set register pointer
	LDD  R26,Y+1
	RCALL _I2C_Write
; 0004 0050     I2C_Start(busAddr + READ); // restart as a read operation
	LDD  R26,Y+2
	SUBI R26,-LOW(1)
	RCALL _I2C_Start
; 0004 0051     data = I2C_ReadNACK(); // read the register data
	RCALL _I2C_ReadNACK
	MOV  R17,R30
; 0004 0052     I2C_Stop(); // stop
	LDI  R30,LOW(148)
	OUT  0x36,R30
; 0004 0053     return data;
	MOV  R30,R17
	LDD  R17,Y+0
	JMP  _0x20A0001
; 0004 0054 }
; .FEND
; 0005 0001 /*****************************************************
; 0005 0002 This program was produced by the
; 0005 0003 CodeWizardAVR V2.05.6 Evaluation
; 0005 0004 Automatic Program Generator
; 0005 0005 � Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
; 0005 0006 http://www.hpinfotech.com
; 0005 0007 
; 0005 0008 
; 0005 0009 
; 0005 000A 
; 0005 000B Chip type               : ATmega16
; 0005 000C Program type            : Application
; 0005 000D AVR Core Clock frequency: 4.000000 MHz
; 0005 000E Memory model            : Small
; 0005 000F External RAM size       : 0
; 0005 0010 Data Stack size         : 256
; 0005 0011  *****************************************************/
; 0005 0012 
; 0005 0013 #include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
; 0005 0014 
; 0005 0015 
; 0005 0016 //#include <myds1307rtc.h>
; 0005 0017 #include <myds1307rtcver2.h>
;
;
;//#include <myds18b20ver1.h>
;#include <myds18b20ver2.h>
;
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#include <io.h>
;#include <interrupt.h>
;	flags -> R17

	.CSEG
;
;#define IS_MASTER 1
;#define MY_ADDRESS 2
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index, rx_rd_index, rx_counter;
;#else
;unsigned int rx_wr_index, rx_rd_index, rx_counter;
;#endif
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;// USART Receiver interrupt service routine
;
;
;// Declare your global variables here
;unsigned char ma[] = {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};

	.DSEG
;void quet(unsigned char x);
;void day();
;void hienthi(int x);
;
;void hienthinhietdo(unsigned char temp);
;void hienthithoigian(unsigned char hour, unsigned char minute);
;
;void uart_char_tx(unsigned char chr);
;unsigned char uart_getchar();
;void getState(unsigned char);
;void process_received_data();
;
;float temp;
;unsigned char kytu = '';
;unsigned char b = 2;
;unsigned char received_byte = '';
;unsigned char received_package[10];
;int isComplete = 1;
;int package_size = 0;
;int slave_enable = 0;
;
;byte ttemp0; // first byte
;byte ttemp1;
;
;void execute_query();
;void send_confirm_to_master();
;// thuc thi cau lenh doc tu goi tin (package))
;
;void execute_query() {
; 0005 0057 void execute_query() {

	.CSEG
_execute_query:
; .FSTART _execute_query
; 0005 0058     Time t;
; 0005 0059 
; 0005 005A     if (IS_MASTER) {
	SBIW R28,9
;	t -> Y+0
; 0005 005B         if (package_size == 4) {
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R12
	CPC  R31,R13
	BRNE _0xA0006
; 0005 005C             if (received_package[2] == 't') {
	__GETB2MN _received_package,2
	CPI  R26,LOW(0x74)
	BRNE _0xA0007
; 0005 005D                 //printf ("%c",a);
; 0005 005E                 temp = ds18b20_gettemp();
	RCALL SUBOPT_0x4
; 0005 005F                 uart_char_tx('T');
	LDI  R26,LOW(84)
	RCALL _uart_char_tx
; 0005 0060                 printf(" Nhiet do hien tai la %d oC\n\r", (unsigned char) temp);
	__POINTW1FN _0xA0000,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0005 0061 
; 0005 0062             }
; 0005 0063             if (received_package[2] == 'h') {
_0xA0007:
	__GETB2MN _received_package,2
	CPI  R26,LOW(0x68)
	BRNE _0xA0008
; 0005 0064                 t = myGetTimeFromDS1307ver2();
	RCALL _myGetTimeFromDS1307ver2
	MOVW R26,R28
	RCALL __COPYMML
	OUT  SREG,R1
; 0005 0065                 printf(" Gio hien tai la %d:%d:%d\n\r", (unsigned char) (t.Hour + t.Mode * t.AP * 12), (unsigned char) t ...
	__POINTW1FN _0xA0000,30
	ST   -Y,R31
	ST   -Y,R30
	LDD  R22,Y+4
	CLR  R23
	LDD  R26,Y+9
	CLR  R27
	LDD  R30,Y+10
	RCALL SUBOPT_0x7
	LDI  R31,0
	RCALL SUBOPT_0x6
	LDD  R30,Y+7
	RCALL SUBOPT_0x6
	LDD  R30,Y+10
	RCALL SUBOPT_0x6
	LDI  R24,12
	RCALL _printf
	ADIW R28,14
; 0005 0066 
; 0005 0067             }
; 0005 0068 
; 0005 0069         }
_0xA0008:
; 0005 006A     }
_0xA0006:
; 0005 006B     package_size = 0;
	CLR  R12
	CLR  R13
; 0005 006C }
	ADIW R28,9
	RET
; .FEND
;
;// doc tung byte va luu vao goi tin theo dinh dang
;
;void process_received_data() {
; 0005 0070 void process_received_data() {
_process_received_data:
; .FSTART _process_received_data
; 0005 0071     if (IS_MASTER) {
; 0005 0072         // xu ly du lieu nhan duoc tren master
; 0005 0073         if (isComplete) {
	MOV  R0,R10
	OR   R0,R11
	BREQ _0xA000A
; 0005 0074             if (received_byte == '@') {
	LDI  R30,LOW(64)
	CP   R30,R8
	BRNE _0xA000B
; 0005 0075                 //printf("bat dau goi tin; ");
; 0005 0076                 isComplete = 0;
	CLR  R10
	CLR  R11
; 0005 0077                 received_package[package_size] = received_byte;
	RCALL SUBOPT_0x8
; 0005 0078                 package_size++;
; 0005 0079             }
; 0005 007A         } else {
_0xA000B:
	RJMP _0xA000C
_0xA000A:
; 0005 007B             received_package[package_size] = received_byte;
	RCALL SUBOPT_0x8
; 0005 007C             package_size++;
; 0005 007D             if ((received_byte == '#') || (package_size > 9)) {
	LDI  R30,LOW(35)
	CP   R30,R8
	BREQ _0xA000E
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R12
	CPC  R31,R13
	BRGE _0xA000D
_0xA000E:
; 0005 007E                 //printf("ket thuc goi tin; ");
; 0005 007F                 isComplete = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
; 0005 0080                 execute_query();
	RCALL _execute_query
; 0005 0081             }
; 0005 0082         }
_0xA000D:
_0xA000C:
; 0005 0083     } else {
; 0005 0084         // xu ly du lieu nhan duoc tren slave
; 0005 0085     }
; 0005 0086 }
	RET
; .FEND
;
;void send_confirm_to_master() {
; 0005 0088 void send_confirm_to_master() {
_send_confirm_to_master:
; .FSTART _send_confirm_to_master
; 0005 0089     uart_char_tx('$');
	LDI  R26,LOW(36)
	RCALL _uart_char_tx
; 0005 008A }
	RET
; .FEND
;
;void enable_slave(){
; 0005 008C void enable_slave(){
_enable_slave:
; .FSTART _enable_slave
; 0005 008D     slave_enable = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _slave_enable,R30
	STS  _slave_enable+1,R31
; 0005 008E     UCSRA &=~(1<<MPCM);
	CBI  0xB,0
; 0005 008F }
	RET
; .FEND
;
;void disable_slave(){
; 0005 0091 void disable_slave(){
; 0005 0092     slave_enable = 0;
; 0005 0093     UCSRA |=(1<<MPCM);
; 0005 0094 }
;
;// xu ly ngat nhan du lieu
;interrupt [USART_RXC] void usart_rx_isr(void) {
; 0005 0097 interrupt [12] void usart_rx_isr(void) {
_usart_rx_isr:
; .FSTART _usart_rx_isr
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
; 0005 0098     if (IS_MASTER) {
; 0005 0099         // xu ly ngat nhan du lieu tren master
; 0005 009A         received_byte = UDR;
	IN   R8,12
; 0005 009B         process_received_data();
	RCALL _process_received_data
; 0005 009C     } else {
; 0005 009D         //xu ly ngat nhan du lieu tren slave
; 0005 009E         if (slave_enable) {
; 0005 009F             process_received_data();
; 0005 00A0         }
; 0005 00A1         else{
; 0005 00A2             if (MY_ADDRESS == received_byte) {
; 0005 00A3                 enable_slave();
; 0005 00A4                 send_confirm_to_master();
; 0005 00A5             }
; 0005 00A6         }
; 0005 00A7     }
; 0005 00A8 }
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
; .FEND
;
;char mygetchar(void) {
; 0005 00AA char mygetchar(void) {
; 0005 00AB     char data;
; 0005 00AC     if (rx_counter == 0) return 0;
;	data -> R17
; 0005 00AD     data = rx_buffer[rx_rd_index];
; 0005 00AE     if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index = 0;
; 0005 00AF     //#asm("cli")
; 0005 00B0     --rx_counter;
; 0005 00B1     //#asm("sei")
; 0005 00B2     return data;
; 0005 00B3 }
;
;// Declare your global variables here
;unsigned char my_variable;
;
;void main(void) {
; 0005 00B8 void main(void) {
_main:
; .FSTART _main
; 0005 00B9     // Declare your local variables here
; 0005 00BA     unsigned char *t = 0;
; 0005 00BB     unsigned char h, m, s, i;
; 0005 00BC     int x;
; 0005 00BD     Time time = {30, 15, 10, 5, 12, 5, 16, 1, 1}; // thoi gian hien tai
; 0005 00BE     // Input/Output Ports initialization
; 0005 00BF     // Port A initialization
; 0005 00C0     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0005 00C1     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0005 00C2     PORTA = 0x00;
	SBIW R28,11
	LDI  R24,9
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xA0018*2)
	LDI  R31,HIGH(_0xA0018*2)
	RCALL __INITLOCB
;	*t -> R16,R17
;	h -> R19
;	m -> R18
;	s -> R21
;	i -> R20
;	x -> Y+9
;	time -> Y+0
	__GETWRN 16,17,0
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0005 00C3     //    DDRA = 0x00;
; 0005 00C4     DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0005 00C5 
; 0005 00C6     // Port B initialization
; 0005 00C7     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0005 00C8     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0005 00C9     PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0005 00CA     DDRB = 0x00;
	OUT  0x17,R30
; 0005 00CB 
; 0005 00CC     // Port C initialization
; 0005 00CD     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0005 00CE     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0005 00CF     PORTC = 0x00;
	OUT  0x15,R30
; 0005 00D0     //    DDRC = 0xFF;
; 0005 00D1     DDRC = 0x00;
	OUT  0x14,R30
; 0005 00D2 
; 0005 00D3     // Port D initialization
; 0005 00D4     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0005 00D5     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0005 00D6     PORTD = 0x00;
	OUT  0x12,R30
; 0005 00D7     DDRD = 0x00;
	OUT  0x11,R30
; 0005 00D8 
; 0005 00D9     // Timer/Counter 0 initialization
; 0005 00DA     // Clock source: System Clock
; 0005 00DB     // Clock value: Timer 0 Stopped
; 0005 00DC     // Mode: Normal top=0xFF
; 0005 00DD     // OC0 output: Disconnected
; 0005 00DE     TCCR0 = 0x00;
	OUT  0x33,R30
; 0005 00DF     TCNT0 = 0x00;
	OUT  0x32,R30
; 0005 00E0     OCR0 = 0x00;
	OUT  0x3C,R30
; 0005 00E1 
; 0005 00E2     // Timer/Counter 1 initialization
; 0005 00E3     // Clock source: System Clock
; 0005 00E4     // Clock value: Timer1 Stopped
; 0005 00E5     // Mode: Normal top=0xFFFF
; 0005 00E6     // OC1A output: Discon.
; 0005 00E7     // OC1B output: Discon.
; 0005 00E8     // Noise Canceler: Off
; 0005 00E9     // Input Capture on Falling Edge
; 0005 00EA     // Timer1 Overflow Interrupt: Off
; 0005 00EB     // Input Capture Interrupt: Off
; 0005 00EC     // Compare A Match Interrupt: Off
; 0005 00ED     // Compare B Match Interrupt: Off
; 0005 00EE     TCCR1A = 0x00;
	OUT  0x2F,R30
; 0005 00EF     TCCR1B = 0x00;
	OUT  0x2E,R30
; 0005 00F0     TCNT1H = 0x00;
	OUT  0x2D,R30
; 0005 00F1     TCNT1L = 0x00;
	OUT  0x2C,R30
; 0005 00F2     ICR1H = 0x00;
	OUT  0x27,R30
; 0005 00F3     ICR1L = 0x00;
	OUT  0x26,R30
; 0005 00F4     OCR1AH = 0x00;
	OUT  0x2B,R30
; 0005 00F5     OCR1AL = 0x00;
	OUT  0x2A,R30
; 0005 00F6     OCR1BH = 0x00;
	OUT  0x29,R30
; 0005 00F7     OCR1BL = 0x00;
	OUT  0x28,R30
; 0005 00F8 
; 0005 00F9     // Timer/Counter 2 initialization
; 0005 00FA     // Clock source: System Clock
; 0005 00FB     // Clock value: Timer2 Stopped
; 0005 00FC     // Mode: Normal top=0xFF
; 0005 00FD     // OC2 output: Disconnected
; 0005 00FE     ASSR = 0x00;
	OUT  0x22,R30
; 0005 00FF     TCCR2 = 0x00;
	OUT  0x25,R30
; 0005 0100     TCNT2 = 0x00;
	OUT  0x24,R30
; 0005 0101     OCR2 = 0x00;
	OUT  0x23,R30
; 0005 0102 
; 0005 0103     // External Interrupt(s) initialization
; 0005 0104     // INT0: Off
; 0005 0105     // INT1: Off
; 0005 0106     // INT2: Off
; 0005 0107     MCUCR = 0x00;
	OUT  0x35,R30
; 0005 0108     MCUCSR = 0x00;
	OUT  0x34,R30
; 0005 0109 
; 0005 010A     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0005 010B     TIMSK = 0x00;
	OUT  0x39,R30
; 0005 010C 
; 0005 010D     // USART initialization
; 0005 010E     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0005 010F     // USART Receiver: On
; 0005 0110     // USART Transmitter: On
; 0005 0111     // USART Mode: Asynchronous
; 0005 0112     // USART Baud Rate: 9600
; 0005 0113     UCSRA = 0x00;
	OUT  0xB,R30
; 0005 0114     UCSRC = (1 << URSEL) | (1 << UCSZ1) | (1 << UCSZ0);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0005 0115     UCSRB = (1 << RXEN) | (1 << TXEN) | (1 << RXCIE) | (1 << UCSZ2);
	LDI  R30,LOW(156)
	OUT  0xA,R30
; 0005 0116     UBRRH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0005 0117     UBRRL = 0x19;
	LDI  R30,LOW(25)
	OUT  0x9,R30
; 0005 0118 
; 0005 0119     // Analog Comparator initialization
; 0005 011A     // Analog Comparator: Off
; 0005 011B     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0005 011C     ACSR = 0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0005 011D     SFIOR = 0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0005 011E 
; 0005 011F     // ADC initialization
; 0005 0120     // ADC disabled
; 0005 0121     ADCSRA = 0x00;
	OUT  0x6,R30
; 0005 0122 
; 0005 0123     // SPI initialization
; 0005 0124     // SPI disabled
; 0005 0125     SPCR = 0x00;
	OUT  0xD,R30
; 0005 0126 
; 0005 0127     // TWI initialization
; 0005 0128     // TWI disabled
; 0005 0129     TWCR = 0x00;
	OUT  0x36,R30
; 0005 012A 
; 0005 012B     // I2C Bus initialization
; 0005 012C     // I2C Port: PORTA
; 0005 012D     // I2C SDA bit: 1
; 0005 012E     // I2C SCL bit: 0
; 0005 012F     // Bit Rate: 100 kHz
; 0005 0130     // Note: I2C settings are specified in the
; 0005 0131     // Project|Configure|C Compiler|Libraries|I2C menu.
; 0005 0132     //    i2c_init();
; 0005 0133 
; 0005 0134     // 1 Wire Bus initialization
; 0005 0135     // 1 Wire Data port: PORTB
; 0005 0136     // 1 Wire Data bit: 0
; 0005 0137     // Note: 1 Wire port settings are specified in the
; 0005 0138     // Project|Configure|C Compiler|Libraries|1 Wire menu.
; 0005 0139     //    w1_init();
; 0005 013A     //    ds18b20_init(t, 0, 0, DS18B20_9BIT_RES);
; 0005 013B     //    rtc_init(0, 0, 0);
; 0005 013C 
; 0005 013D     //    TWI_Init(); //khoi dong TWI dung cho myds1307rtc.h
; 0005 013E     I2C_Init(); //khoi dong TWI dung cho myds1307rtcver2.h
	RCALL _I2C_Init
; 0005 013F 
; 0005 0140     // Global enable interrupts
; 0005 0141 #asm("sei")
	sei
; 0005 0142 
; 0005 0143     while (1) {
_0xA0019:
; 0005 0144 
; 0005 0145         // nhiet do
; 0005 0146         int whole = 0, decimal = 0;
; 0005 0147 
; 0005 0148         // hien thi nhiet do su dung myds18b20ver1.h
; 0005 0149         //        therm_ReadTempC(NULL, &whole, &decimal);
; 0005 014A         //        hienthinhietdo(whole);
; 0005 014B 
; 0005 014C         // hien thi nhiet do su dung myds18b20ver2.h
; 0005 014D         temp = ds18b20_gettemp();
	SBIW R28,4
	RCALL SUBOPT_0x1
;	x -> Y+13
;	time -> Y+4
;	whole -> Y+2
;	decimal -> Y+0
	RCALL SUBOPT_0x4
; 0005 014E         hienthinhietdo(temp);
	RCALL SUBOPT_0x5
	MOV  R26,R30
	RCALL _hienthinhietdo
; 0005 014F 
; 0005 0150         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0005 0151 
; 0005 0152         //        temp = ds18b20_temperature(t);
; 0005 0153 
; 0005 0154         // lay thoi gian
; 0005 0155         //        mySetTimeForDS1307ver2(&time);
; 0005 0156         //        time = myGetTimeFromDS1307();
; 0005 0157         time = myGetTimeFromDS1307ver2();
	RCALL _myGetTimeFromDS1307ver2
	MOVW R26,R28
	ADIW R26,4
	RCALL __COPYMML
	OUT  SREG,R1
; 0005 0158         hienthithoigian(time.Hour + time.Mode * time.AP * 12, time.Minute); // hien thi theo 24h
	LDD  R22,Y+6
	CLR  R23
	LDD  R26,Y+11
	CLR  R27
	LDD  R30,Y+12
	RCALL SUBOPT_0x7
	ST   -Y,R30
	LDD  R26,Y+6
	RCALL _hienthithoigian
; 0005 0159         delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0005 015A 
; 0005 015B 
; 0005 015C         // kytu = mygetchar();
; 0005 015D         // if(kytu !=0) putchar(kytu);
; 0005 015E         // printf("%c", my_variable);
; 0005 015F         //printf("Nhiet do hien tai la");
; 0005 0160         //kytu = uart_getchar();
; 0005 0161 
; 0005 0162 
; 0005 0163 
; 0005 0164 
; 0005 0165     }
	ADIW R28,4
	RJMP _0xA0019
; 0005 0166 }
_0xA001C:
	RJMP _0xA001C
; .FEND
;
;void hienthinhietdo(unsigned char temp) {
; 0005 0168 void hienthinhietdo(unsigned char temp) {
_hienthinhietdo:
; .FSTART _hienthinhietdo
; 0005 0169     unsigned char a, b;
; 0005 016A     a = temp / 10;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	temp -> Y+2
;	a -> R17
;	b -> R16
	LDD  R26,Y+2
	RCALL SUBOPT_0x9
; 0005 016B     b = temp % 10;
	LDD  R26,Y+2
	RCALL SUBOPT_0xA
; 0005 016C 
; 0005 016D 
; 0005 016E     quet(0xC6);
	LDI  R26,LOW(198)
	RCALL _quet
; 0005 016F     quet(0x9C);
	LDI  R26,LOW(156)
	RCALL SUBOPT_0xB
; 0005 0170     quet(ma[b]);
	LD   R26,Z
	RCALL SUBOPT_0xC
; 0005 0171     quet(ma[a]);
; 0005 0172     day(); // push
; 0005 0173 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0001
; .FEND
;
;void hienthithoigian(unsigned char hour, unsigned char minute) {
; 0005 0175 void hienthithoigian(unsigned char hour, unsigned char minute) {
_hienthithoigian:
; .FSTART _hienthithoigian
; 0005 0176     unsigned char a, b, c, d;
; 0005 0177     a = hour / 10;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	hour -> Y+5
;	minute -> Y+4
;	a -> R17
;	b -> R16
;	c -> R19
;	d -> R18
	LDD  R26,Y+5
	RCALL SUBOPT_0x9
; 0005 0178     b = hour % 10;
	LDD  R26,Y+5
	RCALL SUBOPT_0xA
; 0005 0179     c = minute / 10;
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R19,R30
; 0005 017A     d = minute % 10;
	LDD  R26,Y+4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R18,R30
; 0005 017B     quet(ma[d]);
	RCALL SUBOPT_0xD
	RCALL _quet
; 0005 017C     quet(ma[c]);
	MOV  R30,R19
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xB
; 0005 017D     quet(~(~ma[b] | 0x80));
	LD   R30,Z
	COM  R30
	ORI  R30,0x80
	COM  R30
	MOV  R26,R30
	RCALL SUBOPT_0xC
; 0005 017E     quet(ma[a]);
; 0005 017F     day();
; 0005 0180 }
	RCALL __LOADLOCR4
	ADIW R28,6
	RET
; .FEND
;
;void hienthi(int x) {
; 0005 0182 void hienthi(int x) {
; 0005 0183     unsigned char a, b, c, d;
; 0005 0184     int i = 0;
; 0005 0185     a = x / 1000;
;	x -> Y+6
;	a -> R17
;	b -> R16
;	c -> R19
;	d -> R18
;	i -> R20,R21
; 0005 0186     b = (x % 1000) / 100;
; 0005 0187     c = (x % 100) / 10;
; 0005 0188     d = (x % 10);
; 0005 0189 
; 0005 018A     quet(ma[a]);
; 0005 018B     quet(ma[b]);
; 0005 018C     quet(ma[c]);
; 0005 018D     quet(ma[d]);
; 0005 018E 
; 0005 018F     day();
; 0005 0190 }
;
;void quet(unsigned char x) {
; 0005 0192 void quet(unsigned char x) {
_quet:
; .FSTART _quet
; 0005 0193     unsigned char i, temp;
; 0005 0194     for (i = 0; i < 8; i++) {
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	x -> Y+2
;	i -> R17
;	temp -> R16
	LDI  R17,LOW(0)
_0xA001E:
	CPI  R17,8
	BRSH _0xA001F
; 0005 0195         temp = x;
	LDD  R16,Y+2
; 0005 0196         temp = temp & 0x80;
	ANDI R16,LOW(128)
; 0005 0197         if (temp == 0x80) {
	CPI  R16,128
	BRNE _0xA0020
; 0005 0198             PORTA.1 = 1;
	SBI  0x1B,1
; 0005 0199         } else {
	RJMP _0xA0023
_0xA0020:
; 0005 019A             PORTA.1 = 0;
	CBI  0x1B,1
; 0005 019B         }
_0xA0023:
; 0005 019C         x = x * 2;
	LDD  R26,Y+2
	LDI  R30,LOW(2)
	MUL  R30,R26
	MOVW R30,R0
	STD  Y+2,R30
; 0005 019D         PORTA.0 = 0;
	CBI  0x1B,0
; 0005 019E         PORTA.0 = 1;
	SBI  0x1B,0
; 0005 019F     }
	SUBI R17,-1
	RJMP _0xA001E
_0xA001F:
; 0005 01A0 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0001
; .FEND
;
;void day() {
; 0005 01A2 void day() {
_day:
; .FSTART _day
; 0005 01A3     PORTA.2 = 0;
	CBI  0x1B,2
; 0005 01A4     PORTA.2 = 1;
	SBI  0x1B,2
; 0005 01A5 }
	RET
; .FEND
;
;//chuong trinh con phat du lieu
;
;void uart_char_tx(unsigned char chr) {
; 0005 01A9 void uart_char_tx(unsigned char chr) {
_uart_char_tx:
; .FSTART _uart_char_tx
; 0005 01AA     while (!(UCSRA & (1 << UDRE))); //cho den khi bit UDRE=1 moi thoat khoi while
	ST   -Y,R26
;	chr -> Y+0
_0xA002E:
	SBIS 0xB,5
	RJMP _0xA002E
; 0005 01AB     UDR = chr;
	LD   R30,Y
	OUT  0xC,R30
; 0005 01AC }
	RJMP _0x20A0002
; .FEND
;
;unsigned char uart_getchar() {
; 0005 01AE unsigned char uart_getchar() {
; 0005 01AF     unsigned char a = '';
; 0005 01B0     a = UDR;
;	a -> R17
; 0005 01B1     return a;
; 0005 01B2 }
;
;void getState(unsigned char a) {
; 0005 01B4 void getState(unsigned char a) {
; 0005 01B5     switch (a) {
;	a -> Y+0
; 0005 01B6         case 't':
; 0005 01B7             printf("Nhiet do hien tai la %f", temp);
; 0005 01B8             break;
; 0005 01B9         case 'h':
; 0005 01BA             printf("xin chao");
; 0005 01BB             break;
; 0005 01BC     }
; 0005 01BD }
;
;//interrupt [USART_RXC] void rx_isr(){ //ngat nhan khi bit RXC =1
;//  kytu = UDR;
;//}
;
;

	.CSEG

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0002:
	ADIW R28,1
	RET
; .FEND
_put_usart_G101:
; .FSTART _put_usart_G101
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x20A0001:
	ADIW R28,3
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0xE
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0xE
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0xF
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x10
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x11
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x12
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x12
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0xE
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x10
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0xE
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x10
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G101)
	LDI  R31,HIGH(_put_usart_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG

	.DSEG
_registry_ds1307:
	.BYTE 0x7
_rx_buffer:
	.BYTE 0x8
_ma:
	.BYTE 0xA
_temp:
	.BYTE 0x4
_received_package:
	.BYTE 0xA
_slave_enable:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	CBI  0x18,0
	SBI  0x17,0
	__DELAY_USB 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(208)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP _I2C_ReadRegister

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LD   R30,Y
	OUT  0x3,R30
	LDI  R30,LOW(132)
	OUT  0x36,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	RCALL _ds18b20_gettemp
	STS  _temp,R30
	STS  _temp+1,R31
	STS  _temp+2,R22
	STS  _temp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	LDS  R30,_temp
	LDS  R31,_temp+1
	LDS  R22,_temp+2
	LDS  R23,_temp+3
	RCALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	LDI  R31,0
	RCALL __MULW12
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	RCALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	MOVW R30,R12
	SUBI R30,LOW(-_received_package)
	SBCI R31,HIGH(-_received_package)
	ST   Z,R8
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	RCALL _quet
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_ma)
	SBCI R31,HIGH(-_ma)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	RCALL _quet
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_ma)
	SBCI R31,HIGH(-_ma)
	LD   R26,Z
	RCALL _quet
	RJMP _day

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R31,0
	SUBI R30,LOW(-_ma)
	SBCI R31,HIGH(-_ma)
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xE:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xF:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__NEB12:
	CP   R30,R26
	LDI  R30,1
	BRNE __NEB12T
	CLR  R30
__NEB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
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
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__COPYMML:
	CLR  R25
__COPYMM:
	PUSH R30
	PUSH R31
__COPYMM0:
	LD   R22,Z+
	ST   X+,R22
	SBIW R24,1
	BRNE __COPYMM0
	POP  R31
	POP  R30
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
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
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
	MOVW R22,R30
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
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
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

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x3E8
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
