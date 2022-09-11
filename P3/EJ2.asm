processor 16f877 ;Indica la versión de procesador
	include <p16f877.inc> ;Incluye la librería de la versión del procesador
	;contador equ h'01';
	valor1 equ h'21'
	valor2 equ h'22'
	valor3 equ h'23'
	cte1 equ 40h
	cte2 equ 100h
	cte3 equ 120h
 	org 0H ;Carga al vector de RESET la dirección de inicio
 	goto inicio
 	org 05H ;Dirección de inicio del programa del usuario
inicio: CLRF PORTA
 	BSF STATUS,RP0 ;Cambia la banco 1
 	BCF STATUS,RP1
  	MOVLW 06H ;Configura puertos A y B como digitales
 	MOVWF ADCON1; PORTA Digital
 	MOVLW h'ff' ; WREG cpm ff
 	MOVWF TRISA; De WREG a TRISA
	CLRF TRISB; PORT B como salida digital
 	BCF STATUS,RP0 ;Regresa al banco cero
PUERTOA: CLRF PORTB; LIMPIAMOS PORTB
	MOVF PORTA,0; Lee contenido PORTA (IN) y lo manda a WREG
	XORLW h'00'; Evaluamos el caso donde IN vale 0
	BTFSC STATUS,Z; Z = 1 ?
	CALL CASO1; 	Si, vamos a CASO1, TODO APAGADO
	MOVF PORTA,0;	PORTA -> WREG
	XORLW h'01'; 	XOR para valor 01
	BTFSC STATUS,Z;	Z = 1?
	CALL CASO2; 	Si, vamos a CASO2, TODO ENCENDIDO
	MOVF PORTA,0;	No, hacemos PORTA -> WREG
	XORLW h'02'; 	XOR para valor 03
	BTFSC STATUS,Z;	Z = 1?
	CALL CASO3; 	Si, vamos a CASO3, CORRIMIENTO A LA DERECHA
	MOVF PORTA,0;	No, hacemos PORTA -> WREG
	XORLW h'03'; 	XOR para valor 04
	BTFSC STATUS,Z;	Z = 1?
	CALL CASO4; 	Si, vamos a CASO4, CORRIMIENTO A LA IZQUIERDA
	MOVF PORTA,0;	No, hacemos PORTA -> WREG
	XORLW h'04'; 	XOR para valor 04
	BTFSC STATUS,Z;	Z = 1?
	CALL CASO5; 	Si, vamos a CASO5, AMBOS CORRIMIENTOS
	MOVF PORTA,0;	No, hacemos PORTA -> WREG
	XORLW h'05'; 	XOR para valor 04 en WREG
	BTFSC STATUS,Z;	Z = 1?
	CALL CASO6; 	Si, vamos a CASO6, ENCENDIDO / APAGADO
	GOTO PUERTOA;	No, vamos a PUERTOA

;FUNCIONES LLAMADAS DE CASOS
CASO1: CLRF PORTB; APAGAMOS TODOS LOS LEDS
	GOTO PUERTOA; VOLVEMOS A PUERTOA
CASO2: CLRF PORTB; LIMPIAMOS PORTB | TODO ENCENDIDO
	MOVLW h'ff'; TODO WREG ENCENDIDO
	MOVWF PORTB; WREG -> PORTB TODO ENCENDIDO
	GOTO PUERTOA;
CASO3: BSF PORTB,7; PONE BIT 7 EN 1
	CALL retardo;	Llama retardo
CORRER: RRF PORTB,1;	Corimiento a la derecha de 1 en 1 | CORRIMIENTO DER
	call retardo; 	
	btfss PORTB,0;		Valor de Z en PORTB
	goto CORRER;		Z = 0
	goto PUERTOA;		Z = 1
CASO4: BSF PORTB,0; PONE BIT 7 EN 1
	CALL retardo;	Llama retardo
CORRER: RLF PORTB,1;	Corimiento a la derecha de 1 en 1 | CORRIMIENTO DER
	call retardo; 	
	btfss PORTB,0;		Valor de Z en PORTB
	goto CORRER;		Z = 0
	goto PUERTOA;		Z = 1
	CALL CASO4;		Z = 1
CASO5: GOTO PUERTOA; | AMBOS CORRIMIENTOS
	

CASO6: CLRF PORTB; PORTB EN 0 | ENCENDER/APAGAR
	CALL retardo; LLAMAMOS A RETARDO
	MOVLW h'ff'; TODO WREG ENCENDIDO
	MOVWF PORTB; WREG -> PORTB TODO ENCENDIDO
	CALL retardo;
	GOTO PUERTOA; 

retardo movlw cte1;		Escribimos en W el registro cte1
 	movwf valor1;		
tres movlw cte2
 	movwf valor2
dos movlw cte3
 	movwf valor3
uno decfsz valor3
 	goto uno
 	decfsz valor2
 	goto dos
 	decfsz valor1
 	goto tres
return
END;