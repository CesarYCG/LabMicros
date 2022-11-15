;Codigo chido
processor p16f877 
include <p16f877.inc> 
	
	T  EQU H'20'			; REGISTRO T PARA LEER POR TECLADO
	cte1 equ 20h			; REGISTROS PARA CAMBIOS DE VALOR
	cte2 equ 50h
	cte3 equ 60h

	valor1 equ h'21'
	valor2 equ h'22'
	valor3 equ h'23'

	org 0h 
	goto INICIO
	org 5h 
							; CONFIGURACION DE REGISTROS PARA
							; PUERTO SERIE SCI (ASINCRONO)
INICIO:
	BSF STATUS,RP0	; Cambiamos al banco 1
	BCF STATUS,RP1
	CLRF TRISB		; Puerto B tiene salidas digitales
					; CONFIGURACION DE REG. TXSTA ASINCRONO
	BSF TXSTA,BRGH	; ACTIVAMOS ALTA VELOCIDAD
	BCF TXSTA,SYNC	; ACTIVAMOS COM. ASINCRONA
	BSF TXSTA,TXEN	; ACTIVAMOS LA TRANSMISION
	MOVLW D'32'		; Para 38400 de baud rate BCRG -> W
	MOVWF SPBRG		; DE W -> SPBRG
	BCF STATUS,RP0	; Cambiamos al banco 0
	BSF RCSTA,SPEN	; Habilitamos el puerto serie
	BSF RCSTA,CREN	; Configura la recepción continua en modo de comunicación asíncrona
	CLRF TRISB 		; LIMPIAMOS EL REGISTRO TRISB PARA QUE LA ENTRADA SE REGISTRE

RECIBE:
	BTFSS PIR1,RCIF	; EN PIR1 BIT RCIF = 1? 
	GOTO RECIBE		; NO | Esperamos a recibir un dato
	MOVF RCREG,W	; SI | RCREG -> W 
	MOVWF T			; W -> T
	
LOOP:
	CLRF PORTB		; Limpiamos el puerto B
	BCF STATUS,Z	; REG STATUS BIT Z = 0
	MOVF T,0		; T -> W

	XORLW A'0'		; XOR ACUMULADOR Y VALOR '0' | Validamos si se presionó la tecla 0
	BTFSC STATUS,Z	; REG STATUS BIT Z = 0?
	GOTO CASO0		; NO -> VAMOS A CASO 0
	MOVF T,0		; SI -> T -> REG. ACUMULADOR (0)

	XORLW A'1'		; XOR ACUMULADOR Y VALOR '1' | Validamos si se presionó la tecla 1
	BTFSC STATUS,Z	; REG STATUS BIT Z = 0?
	GOTO CASO1		; NO -> CASO1
	MOVF T,0		; SI -> T -> W

	XORLW A'2'		; XOR ACUMULADOR Y VALOR '2' | Validamos si se presionó la tecla 2
	BTFSC STATUS,Z	; REG STATUS BIT Z = 0?
	GOTO CASO2		; NO -> CASO2
	MOVF T,0 		; SI -> T -> W

	XORLW A'3'		; XOR ACUMULADOR Y VALOR '2' | Validamos si se presionó la tecla 3
	BTFSC STATUS,Z	; REG STATUS BIT Z = 0?
	GOTO CASO3		; NO -> CASO3
	MOVF T,0 		; SI -> T -> W

	XORLW A'4'		; XOR ACUMULADOR Y VALOR '4' | Validamos si se presionó la tecla 4
	BTFSC STATUS,Z	; EG STATUS BIT Z = 0?
	GOTO CASO4		; NO -> CASO4
	GOTO LOOP		; SI -> LOOP

RECIBE2:
	MOVF RCREG,W		; W <- RCREG
	MOVWF TXREG			; TXREG <- W
	BSF STATUS,RP0		; Cambiamos al banco 1

TRANSMITE:
	BTFSS TXSTA,TRMT	; REG TXSTA BIT TRMT = 1 | ¿Se transmitió el dato?
	GOTO TRANSMITE		; NO -> TRANSMITE
	BCF STATUS,RP0		; SI -> Cambiamos al banco 0
	GOTO RECIBE 		; VAMOS A RECIBE


CASO0:				
	CLRF PORTB			; BITS PORTB A CERO
	GOTO RECIBE2		; VAMOS A RECIBE2
	
CASO1:
	MOVLW H'FF'			; 'FF' -> W
	MOVWF PORTB 		; W -> PORTB
	GOTO RECIBE2 		; VAMOS A RECIBE2

CASO2
	bsf PORTB,7		; BIT + SIGNIFICATIVO = 1 EN REG PORTB
CORREDER 
	rrf PORTB,1		; ROTA LOS BITS DE PORTB A LA DERECHA 
	call RETARDO	; VAMOS A RETARDO
	btfss PORTB,0	; REG PORTB BIT 0 = 1? 
	goto CORREDER	; NO -> CORREDER
	GOTO RECIBE2	; SI -> RECIBE2

CASO3
	bsf PORTB,0		; BIT - SIGNIFICATIVO = 1 EN REG PORTB
CORREIZQ
	rlf PORTB,1		; ROTA LOS BITS DE PORTB A LA IZQUIERDA
	call RETARDO	; VAMOS A RETARDO
	btfss PORTB,7	; REG PORTB BIT 7 = 1?
	goto CORREIZQ	; NO -> CORREIZQ
	GOTO RECIBE2	; SI -> RECIBE2


CASO4:
	clrf PORTB		; BITS PORTB A CERO
	bsf PORTB,0		; BIT + SIGNIFICATIVO = 1 EN REG PORTB
	call RETARDO	; VAMOS A RETARDO
CORRL: 
	rlf PORTB,1		; ROTA LOS BITS DE PORTB A LA IZQUIERDA
	call RETARDO	; VAMOS A RETARDO
	btfss PORTB,7	; REG PORTB BIT 7 = 1?
	goto CORRL		; NO -> CORRL
CORRD: 				; SI -> 
	rrf PORTB,1		; ROTA LOS BITS DE PORTB A LA DERECHA 
	call RETARDO	; VAMOS A RETARDO
	btfss PORTB,0	; REG PORTB BIT 0 = 1? 
	goto CORREDER	; NO -> CORREDER
	GOTO RECIBE2	; SI -> RECIBE2

CASO5:
	clrf PORTB		; BITS PORTB A CERO 
	call RETARDO	; VAMOS A RETARDO
	movlw H'FF'		; H'FF' -> W
	movwf PORTB		; W -> PORTB
	GOTO RECIBE2	; VAMOS A RECIBE2	

RETARDO: 
		movlw cte1			; W = CTE1 | W = 20h
 		movwf valor1		; VALOR1 = W 

tres: 	movlw cte2			; W = CTE2 | W = 50h
 		movwf valor2		; VALOR2 = W

dos:	movlw cte3			; W = CTE3 | W = 60h
 		movwf valor3		; VALOR3 = W

uno: 	decfsz valor3		; VALOR3 = VALOR - 1, ¿VALOR1 = 0?
 		goto uno			; NO
 		decfsz valor2		; SI | VALOR2 = VALOR2 - 1, ¿VALOR2 = 0?
 		goto dos			; NO
 		decfsz valor1		; SI
 		goto tres			; VOLVEMOS A TRES
		return
END