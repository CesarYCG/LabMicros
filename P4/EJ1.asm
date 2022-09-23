processor 16f877
include <p16f877.inc>
	org 0
	goto inicio
	org 5
	inicio:
		bsf STATUS, RP0; Cambio de banco
		bcf STATUS, RP1
		movlw 06H
		movwf ADCON1
		movlw 3FH
		movwf TRISA
		clrf TRISB
		clrf TRISC
		bcf STATUS, RP0

switch: movf PORTA,0
	xorlw h'00'
	btfsc STATUS,Z
	call paso1
	movf PORTA,0
	xorlw h'02'
	btfsc STATUS,Z
	call paso2
	movf PORTA,0
	xorlw h'04'
	btfsc STATUS,Z
	call paso3
	movf PORTA,0
	xorlw h'05'
	btfsc STATUS,Z
	call paso4
	movf PORTA,0
	xorlw h'06'
	btfsc STATUS,Z
	call paso5
	xorlw h'07'
	btfsc STATUS,Z
	call paso6
	xorlw h'08'
	btfsc STATUS,Z
	call paso7
	xorlw h'09'
	btfsc STATUS,Z
	call paso8
	xorlw h'10'
	btfsc STATUS,Z
	call paso9
	goto switch

; Funciones de paso
paso1: clrf PORTB
	clrf PORTC
	RETURN

paso2: movlw b'00001010'
	movwf PORTB
	movlw b'00000100'
	movwf PORTC
	RETURN

paso3: movlw b'00000100'
	movwf PORTB
	movlw b'00000100'
	movwf PORTC
	RETURN

paso4: movlw b'00000110'
	movwf PORTB
	movlw b'00000010'
	movwf PORTC
	RETURN

paso5: movlw b'00000001'
	movwf PORTB
	movlw b'00000010'
	movwf PORTC
	RETURN
; NUEVOS PASOS - EJ2
paso6: movlw b'00001010'
	movwf PORTB
	movlw b'00000110'
	movwf PORTC
	RETURN

paso7: movlw b'00000101'
	movwf PORTB
	movlw b'00000110'
	movwf PORTC
	RETURN

paso8: movlw b'00000110'
	movwf PORTB
	movlw b'00000110'
	movwf PORTC
	RETURN

paso9: movlw b'00001001'
	movwf PORTB
	movlw b'00000110'
	movwf PORTC
	RETURN
END
	

