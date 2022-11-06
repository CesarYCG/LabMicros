;Práctica 3 - Ejercicio3

processor pl6f877 ;Versión del procesador a utilizar
include <pl6f877.inc> ;Se cargan las librerias y el mapa de memoria

	J EQU 0X20 ;Localidades para la subrutina de retraso 
	K EQU 0X21 ;Se carga al vector RESET
	
	;Variables para los canales
	CANAL1 EQU H'24' ;Canal 1 en la localidad 24
	CANAL2 EQU H'25' ;Canal 2 en la localidad 25
	CANAL3 EQU H'26' ;Canal 3 en la localidad 26
	 
	org 0h 
	goto inicio ;Su ubicación es en el espacio de memoria "inicio"
	org 5h ;Se ubica en el espacio de memoria 5 

inicio:
	CLRF PORTA ;Limpiamos el puerto A
	BSF STATUS, RP0 ;Nos posicionamos en el banco 1 para poder trabajar con TRIS
	BCF STATUS, RP1 ;Nos cambiamos al banco 1
	MOVLW 00H ;Se configura al puerto a y e como analógico
	MOVWF ADCON1 ;Se coloca en ADCON1 para que todo se digital 
	MOVLW 00H ;Ponemos al puerto B como una salida
	MOVWF TRISB ;Se coloca en TRISB
	BCF STATUS, RP0 ;Retornamos al banco 0
	MOVLW b'11001001' ;Frecuencia del reloj
	MOVWF ADCON0
	CLRF PORTB ;Limpiamos el puertoB

CONVERTIDOR:
	BCF STATUS, C ;Se limpia a C
	BSF ADCON0, 2 ;Se inicia la conversión de a/d
	CALL RETARDO ;Se llama un retardo
	BCF ADCON0,2 ;Se finaliza la conversión 
	MOVFW ADRESH ;Se lee el ediltado de la conversión
	MOVWF CANAL1 ;Se guarda el primer valor
	MOVLW b'11001001' ; Frecuencia de reloj, convertidor a/d
	MOVWF ADCON0
	BCF STATUS, C ;Se limpia el carry 
	BSF ADCON0,2 ; Se inicia la conversión de a/d
	CALL RETARDO ;Se llama un retardo 
	BCF ADCON0,2 ;Se finaliza la conversión
	MOVFW ADRESH ;Se lee el resultado de la conversión 
	MOVWF CANAL2 ;Se guarda el segundo valor

	MOVLW b'11001001' ; Frecuencia de reloj, convertidor a/d
	MOVWF ADCON0
	BCF STATUS, C ;Se limpia el carry 
	BSF ADCON0,2 ; Se inicia la conversión de a/d
	CALL RETARDO ;Se llama un retardo 
	BCF ADCON0,2 ;Se finaliza la conversión
	MOVFW ADRESH ;Se lee el resultado de la conversión 
	MOVWF CANAL3 ;Se guarda el tercer valor

	
	movf CANAL1, e ;Nos movemos a canal1 en W
	SUBWF CANAL2 ;Se hace la resta de CANAL2-CANAL1 y se guarda en W
	BTFSC STATUS, C ;Carry se apaga si el resultado es negativo 
	GOTO OP2 ;Entonces V2>V1
	GOTO P1 ;Entonces V1>V2

	OP1: 
		MOVF CANAL1, w ;Se mueve canal1 en w
		SUBWF CANAL3 ;Se resta CANAL3-CANAL1 y se guarda en W
		BTFSC STATUS, C ;Carry se apaga si el resultado es negativo 
		GOTO P1_23 ;Entonces V1>V3 
		GOTO OP3_12 ;Entonces V3>V1

	OP2:
		MOVF CANAL2, w ;Se mueve canal2 en w
		SUBWF CANAL3 ;Se resta CANAL3-CANAL2 y se guarda en W
		BTFSC STATUS, C ;Carry se apaga si el resultado es negativo 
		GOTO P1_13 ;Entonces V1>V3 
		GOTO OP3_12 ;Entonces V3>V1

	OP1_23:
		 MOVLW H'01' ;Se coloca un 1 en el puerto B
		MOVWF PORTB ;Se carga en el puerto B
		goto convertidor

	OP1_13:
		 MOVLW H'07' ;Se coloca un 1 en el puerto B
		MOVWF PORTB ;Se carga en el puerto B
		goto convertidor
	
	OP1_23:
		 MOVLW H'01' ;Se coloca un 1 en el puerto B
		MOVWF PORTB ;Se carga en el puerto B
		goto convertidor

retardo:
	MOVLW d'25' ;w= 25 en decimal
	MOVWF J ;J = w
jloop: 
	MOVWF K ;K = w
kloop:
	DECFSZ K, f ;Se hace un drecremento en 1 a k
	goto kloop ;Regresamos a jloop
	DECFSZ J, f ;Se decrementa en 1 a J
	goto jloop ;Regresamos a jloop
END