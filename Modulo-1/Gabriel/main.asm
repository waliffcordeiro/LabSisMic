;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.

;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer


;-------------------------------------------------------------------------------
; Main loop here
;-------------------------------------------------------------------------------
NUM			.equ	2319
;
			MOV		#NUM,R5
			MOV		#RESP,R6
			CALL	#ALG_ROM
			JMP		$
			NOP
;
ALG_ROM:	SUB		#1000,R5
			JN		ADD_1000
			NOP
			MOV.B	#'M',1(R6)	;código para colocar M no vetor de resposta
			INC		R6
			JMP		ALG_ROM
			NOP
			RET

CENTENA:	MOV		#4,R7			;Contador para 900
			SUB		#500,R5
			JN		SOMA_500
			NOP
			MOV.B	#'D',1(R6)
			JMP		CENT_100
			RET

SOMA_500:	ADD		#500,R5
			JMP		CENT_100
			RET

CENT_100:	SUB		#100,R5
			JN		SOMA_100
			NOP
			MOV.B	#'C',1(R6)
			DEC		R7
			CMP		#0,R7
			JZ		SOMA_400
			NOP
			JMP		CENT_100
			NOP

SOMA_100:	ADD		#100,R5
			JMP		DEZENA
			NOP

DEZENA:		MOV		#4,R7			;Contador para 900
			SUB		#50,R5
			JN		SOMA_50
			NOP
			MOV.B	#'D',1(R6)
			JMP		DEZ_10
			RET

UNIDADE:	MOV		#4,R7			;Contador para 900
			SUB		#5,R5
			JN		SOMA_5
			NOP
			MOV.B	#'V',1(R6)
			JMP		UNI_1
			RET

SOMA_5:		ADD		#5,R5
			JMP		DEZ_10
			RET

UNI_1:		NOP
			SUB		#1,R5
			JN		SOMA_1
			NOP
			MOV.B	#'I',1(R6)
			DEC		R7
			CMP		#0,R7
			JZ		SOMA_4
			NOP
			JMP		UNI_1
			NOP

SOMA_4:		NOP					;fazer código para tirar os VIII da memória
			MOV.B	#'I',1(R6)
			MOV.B	#'V',1(R6)
			JMP		UNIDADE
			NOP

SOMA_1:		ADD		#1,R5
			RET
			NOP

SOMA_50:	ADD		#50,R5
			JMP		DEZ_10
			RET

DEZ_10:		NOP					; se tirar esse nop buga tudo
			SUB		#10,R5
			JN		SOMA_10
			NOP
			MOV.B	#'C',1(R6)
			DEC		R7
			CMP		#0,R7
			JZ		SOMA_40
			NOP
			JMP		DEZ_10
			NOP

SOMA_40:	NOP					;fazer código para tirar os VIII da memória
			MOV.B	#'X',1(R6)
			MOV.B	#'L',1(R6)
			RET
			NOP

SOMA_10:	ADD		#10,R5
			JMP		UNIDADE
			NOP


SOMA_400:	NOP					;fazer código para tirar os DCCC da memória
			MOV.B	#'C',1(R6)
			MOV.B	#'M',1(R6)
			JMP		DEZENA
			NOP


ADD_1000:	ADD		#1000,R5
			JMP		CENTENA
			RET

FINAL:		NOP
			JMP		$
			NOP


;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            

			.data
RESP:		.byte	"RRRRRRRRRRRRRRRRRRRRRR",0
