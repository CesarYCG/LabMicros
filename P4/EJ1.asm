processor 16f877;			Version del procesador
include <p16f877.inc>;		Libreria de version del procesador
	org 0; 					Carga al vector de RESET la direccion de inicio
	goto inicio;			Vamos a inicio
	org 5;					Direccion de inicio del programa de usuario
	inicio:
		bsf STATUS, RP0; 	Cambio al banco 1
		bcf STATUS, RP1;	Cambio al banco 1
		movlw 06H;			Configura puertos A y B como digitales
		movwf ADCON1;		PORTA Digital
		movlw 3FH;			WREG cambia su valor a 3FH
		movwf TRISA;		WREG -> TRISA
		clrf TRISB;			TRISB = 0, Z-Status = 1
		clrf TRISC;			TRISC = 0, Z-Status = 1
		bcf STATUS, RP0;	Regresamos a Banco 0

; Funcion que determina los pasos
switch: movf PORTA,0 ; 		Se escribe en 0 (WREG) el contenido PORTA
	xorlw h'00';			XOR entre WREG y h'00', si res = 0 -> Z=1
	btfsc STATUS,Z;			Z = 1?
	call paso1;				Si, vamos a paso1
	movf PORTA,0;			No, escribimos en WREG el contenido PORTA
	xorlw h'02';			XOR(WREG,h'02')
	btfsc STATUS,Z;			Z = 1?
	call paso2;				Si, vamos a paso1
	movf PORTA,0;			No, escribimos en WREG el contenido PORTA
	xorlw h'04';			Los pasos anteriores se repiten
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
	; PASOS ACTIVIDAD 2
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
	btfsc STATUS,Z;			Z = 1?
	call paso9;				Si, vamos a paso 9
	goto switch;			No, volvemos a fun. switch

; Funciones de paso
paso1: clrf PORTB;			PORTB = 0 y Z = 1
	clrf PORTC				PORTC = 0 
	RETURN;					Volvemos a la subrutina switch

paso2: movlw b'00001010';	WREG = b'00001010'
	movwf PORTB;			PORTB = WREG
	movlw b'00000100';		WREG = b'00000100'
	movwf PORTC;			PORTC = WREG
	RETURN;					Volvemos a la subrutina switch

paso3: movlw b'00000100';	WREG = b'00000100'
	movwf PORTB;			PORTB = WREG
	movlw b'00000100';		WREG = b'00000100'
	movwf PORTC;			PORTC = WREG
	RETURN;					Volvemos a la subrutina switch

paso4: movlw b'00000110';	El proceso anterior se repite
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
END;						Fin de instrucciones
	

