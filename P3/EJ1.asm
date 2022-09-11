processor 16f877 ;Indica la versión de procesador
	include <p16f877.inc> ;Incluye la librería de la versión del procesador
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
PUERTOA: btfsc PORTA,0; Verifica el estado bit0 en puertoA
	goto ENCENDIDO ;	Vamos a encendido 
	clrf PORTB; 		Sino, limpia PORTB para apagar
	goto PUERTOA; 		vamos a PUERTOA
ENCENDIDO: movlw h'ff'	; Encendemos todos los bits WREG
	movwf PORTB;		Encendemos todos los bits PORTB salida
	goto PUERTOA;		Vamos a PUERTOA
END;					FIN DE INSTRUCCIONES