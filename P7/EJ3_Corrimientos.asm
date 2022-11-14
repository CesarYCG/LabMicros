processor p16f877 
include <p16f877.inc> 
	
	T  EQU H'20'
	cte1 equ 20h
	cte2 equ 50h
	cte3 equ 60h

	valor1 equ h'21'
	valor2 equ h'22'
	valor3 equ h'23'

	org 0h 
	goto INICIO
	org 5h 

INICIO:
	BSF STATUS,RP0	; Cambiamos al banco 1
	BCF STATUS,RP1
	CLRF TRISB		; Puerto B tiene salidas digitales
	BSF TXSTA,BRGH	; Activamos la alta velocidad
	BCF TXSTA,SYNC	; Activamos la comunicación asíncrona
	BSF TXSTA,TXEN	; Activamos la transmisión
	MOVLW D'32'		; Para 38400 de baud rate
	MOVWF SPBRG		; Configuramos la velocidad de comunicación
	BCF STATUS,RP0	; Cambiamos al banco 0
	BSF RCSTA,SPEN	; Habilitamos el puerto serie
	BSF RCSTA,CREN	; Configura la recepción continua en modo de comunicación asíncrona

RECIBE:
	BTFSS PIR1,RCIF	; ¿PIR1.RCIF = 1? 
	GOTO RECIBE		; NO | Esperamos a recibir un dato
	MOVF RCREG,W	; SI | W <- RCREG
	MOVWF T			; T <- W
	
LOOP:
	CLRF PORTB		; Limpiamos el puerto B
	BCF STATUS,Z	; STATUS.Z <- 0
	MOVF T,0		; W <- T
	XORLW A'0'		; Validamos si se presionó la tecla 0
	BTFSC STATUS,Z	; ¿STATUS.Z = 0?
	GOTO CASO0		; NO
	
	MOVF T,0		; SI | W <- T
	XORLW A'1'		; Validamos si se presionó la tecla 1
	BTFSC STATUS,Z	; ¿STATUS.Z = 0?
	GOTO CASO1		; NO
	
	MOVF T,0		; SI | W <- T
	XORLW A'2'		; Validamos si se presionó la tecla 2
	BTFSC STATUS,Z	; ¿STATUS.Z = 0?
	GOTO CASO2		; NO
	
	MOVF T,0
	XORLW A'3'		; Validamos si se presionó la tecla 3
	BTFSC STATUS,Z	; ¿STATUS.Z = 0?
	GOTO CASO3		; NO
	
	MOVF T,0
	XORLW A'4'		; Validamos si se presionó la tecla 4
	BTFSC STATUS,Z	; ¿STATUS.Z = 0?
	GOTO CASO4		; NO

	GOTO LOOP

RECIBE2:
	MOVF RCREG,W		; W <- RCREG
	MOVWF TXREG			; TXREG <- W
	BSF STATUS,RP0		; Cambiamos al banco 1

TRANSMITE:
	BTFSS TXSTA,TRMT	; ¿TXSTA.TRMT = 1?	¿Se transmitió el dato?
	GOTO TRANSMITE		; NO
	BCF STATUS,RP0		; SI | Cambiamos al banco 0
	GOTO RECIBE


CASO0:				
	CLRF PORTB		; Apagamos los bits del puerto B
	GOTO RECIBE2
	
CASO1:
	MOVLW H'FF'		; Encendemos los bits del puerto B
	MOVWF PORTB
	GOTO RECIBE2

CASO2
	bsf PORTB,7		; Encendemos el bit más significativo
CORREDER 
	rrf PORTB,1		; Recorremos hacia la derecha
	call RETARDO	
	btfss PORTB,0	; ¿PORTB.0 = 1? 
	goto CORREDER	; NO
	GOTO RECIBE2	; SI

CASO3
	bsf PORTB,0		; Encendemos el bit menos significativo
CORREIZQ
	rlf PORTB,1		; Recorremos hacia la izquierda
	call RETARDO
	btfss PORTB,7	; ¿PORTB.7 = 1?
	goto CORREIZQ	; NO
	GOTO RECIBE2	; SI


CASO4:
	clrf PORTB			; Limpiamos el puerto B
	bsf PORTB,0			; Encendemos el bit más significativo
	call RETARDO		
CORRL: 
	rlf PORTB,1			; Recorremos hacia la izquierda
	call RETARDO		
	btfss PORTB,7		; ¿PORTB.7 = 1? 
	goto CORRL			; NO
CORRD: 					; SI
	rrf PORTB,1			; Recorremos hacia la derecha
	call RETARDO	
	btfss PORTB,0		; ¿PORTB.0? = 1
	goto CORRD			; NO
	GOTO RECIBE2		; SI

CASO5:
	clrf PORTB			; Limpiamos el puerto B
	call RETARDO	
	movlw H'FF'			; W <-- FFh
	movwf PORTB			; PORTB <-- W
	GOTO RECIBE2		

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
