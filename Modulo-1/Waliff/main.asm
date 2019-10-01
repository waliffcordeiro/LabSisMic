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
NUM			.equ	2019
;
			MOV		#NUM,R5
			MOV		#RESP,R6
			CLR		R7			;Contador de centenas
			CALL	#ALG_ROM
			JMP		$
			NOP
;
ALG_ROM:	SUB		#1000,R5
			JN		ADD_1000
			NOP
			MOV.B	#'M',0(R6)	;código para colocar M no vetor de resposta
			INC		R6
			JMP		ALG_ROM
			NOP
			RET

CENTENA:	SUB		#100,R5
			JN		ADD_100
			INC		R7
			JMP		CENTENA
			NOP
			RET


ADD_1000:	ADD		#1000,R5
			JMP		CENTENA
			RET

ADD_100:	ADD		#100,R5
			CMP		#9,R7		; Compara se é 900
			JHS		NUM_900
			CMP		#8,R7		; Compara se é 800
			JHS		NUM_800
			CMP		#7,R7		; Compara se é 700
			JHS		NUM_700
			CMP		#6,R7		; Compara se é 600
			JHS		NUM_600
			CMP		#5,R7		; Compara se é 500
			JHS		NUM_500
			CMP		#4,R7		; Compara se é 400
			JHS		NUM_400
			CMP		#3,R7		; Compara se é 300
			JHS		NUM_300
			CMP		#2,R7		; Compara se é 200
			JHS		NUM_200
			CMP		#1,R7		; Compara se é 100
			JHS		NUM_100
			JMP		DEZENA		; Se não tem centena, vai pra dezena
			RET

NUM_900:	MOV.B	#'C',0(R6) 	; Adiciona 900 no vetor
			INC		R6
			MOV.B	#'M',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_800:	MOV.B	#'D',0(R6)	; Adiciona 800 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_700:	MOV.B	#'D',0(R6)	; Adiciona 700 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_600:	MOV.B	#'D',0(R6)	; Adiciona 600 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_500:	MOV.B	#'D',0(R6)	; Adiciona 500 no vetor
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA
			RET

NUM_400:	MOV.B	#'C',0(R6)	; Adiciona 400 no vetor
			INC		R6
			MOV.B	#'D',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_300:	MOV.B	#'C',0(R6)	; Adiciona 300 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as dezenas
			RET

NUM_200:	MOV.B	#'C',0(R6)	; Adiciona 200 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA
			RET

NUM_100:	MOV.B	#'C',0(R6)	; Adiciona 100 no vetor
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA
			RET

DEZENA:		SUB		#10,R5
			JN		ADD_10
			INC		R7
			JMP		DEZENA
			NOP
			RET

ADD_10:		ADD		#10,R5
			CMP		#9,R7		; Compara se é 90
			JHS		NUM_90
			CMP		#8,R7		; Compara se é 80
			JHS		NUM_80
			CMP		#7,R7		; Compara se é 70
			JHS		NUM_70
			CMP		#6,R7		; Compara se é 60
			JHS		NUM_60
			CMP		#5,R7		; Compara se é 50
			JHS		NUM_50
			CMP		#4,R7		; Compara se é 40
			JHS		NUM_40
			CMP		#3,R7		; Compara se é 30
			JHS		NUM_30
			CMP		#2,R7		; Compara se é 20
			JHS		NUM_20
			CMP		#1,R7		; Compara se é 10
			JHS		NUM_10
			JMP		UNIDADE		; Se não tem dezena, vai pra unidade
			RET

NUM_90:	    MOV.B	#'X',0(R6) 	; Adiciona 90 no vetor
			INC		R6
			MOV.B	#'C',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as dezenas
			RET

NUM_80:		MOV.B	#'L',0(R6)	; Adiciona 80 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as UNIDADES
			RET

NUM_70:		MOV.B	#'L',0(R6)	; Adiciona 70 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as unidades
			RET

NUM_60:		MOV.B	#'L',0(R6)	; Adiciona 60 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as unidades
			RET

NUM_50:	MOV.B	#'L',0(R6)	; Adiciona 50 no vetor
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE
			RET

NUM_40:		MOV.B	#'X',0(R6)	; Adiciona 40 no vetor
			INC		R6
			MOV.B	#'L',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as unidades
			RET

NUM_30:		MOV.B	#'X',0(R6)	; Adiciona 30 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		DEZENA		; Vai para as unidades
			RET

NUM_20:		MOV.B	#'X',0(R6)	; Adiciona 20 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as unidades
			RET

NUM_10:		MOV.B	#'X',0(R6)	; Adiciona 200
			INC		R6
			CLR		R7			; Zerando o contador
			JMP		UNIDADE		; Vai para as unidades
			RET

UNIDADE:	SUB		#1,R5
			JN		ADD_1
			INC		R7
			JMP		UNIDADE
			NOP
			RET

ADD_1:		ADD		#1,R5
			CMP		#9,R7		; Compara se é 9
			JHS		NUM_9
			CMP		#8,R7		; Compara se é 8
			JHS		NUM_8
			CMP		#7,R7		; Compara se é 7
			JHS		NUM_7
			CMP		#6,R7		; Compara se é 6
			JHS		NUM_6
			CMP		#5,R7		; Compara se é 5
			JHS		NUM_5
			CMP		#4,R7		; Compara se é 4
			JHS		NUM_4
			CMP		#3,R7		; Compara se é 3
			JHS		NUM_3
			CMP		#2,R7		; Compara se é 2
			JHS		NUM_2
			CMP		#1,R7		; Compara se é 1
			JHS		NUM_1
			RET

NUM_9:	    MOV.B	#'I',0(R6) 	; Adiciona 9 no vetor
			INC		R6
			MOV.B	#'X',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_8:		MOV.B	#'V',0(R6)	; Adiciona 8 no vetor
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_7:		MOV.B	#'V',0(R6)	; Adiciona 7 no vetor
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_6:		MOV.B	#'V',0(R6)	; Adiciona 6 no vetor
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_5:	MOV.B	#'V',0(R6)	; Adiciona 5 no vetor
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_4:		MOV.B	#'I',0(R6)	; Adiciona 4 no vetor
			INC		R6
			MOV.B	#'V',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_3:		MOV.B	#'I',0(R6)	; Adiciona 3 no vetor
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_2:		MOV.B	#'I',0(R6)	; Adiciona 2 no vetor
			INC		R6
			MOV.B	#'I',0(R6)
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

NUM_1:		MOV.B	#'I',0(R6)	; Adiciona 1
			INC		R6
			MOV.B	#0x00,0(R6)	; Finalizando a string
			RET

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
RESP:		.byte	"RRRRRRRRRRRRR",0
