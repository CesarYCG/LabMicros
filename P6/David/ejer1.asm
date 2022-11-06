;Práctica 3 - Ejercicio1

processor pl6f877 		;Versión del procesador a utilizar
include <pl6f877.inc> 	;Se cargan las librerias y el mapa de memoria

	J EQU 0X20 			;Localidades para la subrutina de retraso 
	K EQU 0X21 			;Se carga al vector RESET
	
	org 0h 
	goto inicio 		;Su ubicación es en el espacio de memoria "inicio"
	org 5h 				;Se ubica en el espacio de memoria 5 

inicio:
	BSF STATUS, RP0 	;Nos posicionamos en el banco 1 para poder trabajar con TRIS
	BCF STATUS, RP1 	;Nos cambiamos al banco 1
	MOVLW 00H 			;Se configura al puerto A y e como analógico
	MOVWF ADCON1 		;Se coloca en ADCON1 para que todo se digital 
	MOVLW 00H 			;Ponemos al puerto B como una salida
	MOVWF TRISB 		;Se coloca en TRISB
	BCF STATUS, RP0 	;Retornamos al banco 0
	MOVLW b'11001001' 	;Frecuencia del reloj
	MOVWF ADCON0
	CLRF PORTB 			;Limpiamos el puertoB

CONVERTIDOR:
	BSF ADCON0, 2 		;Se inicia la conversión a/d
	CALL RETRADO 		;Llamamos a un retardo para que se haga la conversión
	BCF ADCON0, 2 		;Sef inaliza la conversión 
	MOVFW ADRESH 		;Se lee el rediltado de la convresión 
	MOVWF PORTB 		;Se carga en el puerto B
	GOTO CONVERTIDOR 	;Regresamos a Convertidor 

retardo:
	MOVLW d'25' 		;w= 25 en decimal
	MOVWF J 			;J = w
jloop: 
	MOVWF K 			;K = w
kloop:
	DECFSZ K, f 		;Se hace un drecremento en 1 a k
	goto kloop 			;Regresamos a jloop
	DECFSZ J, f 		;Se decrementa en 1 a J
	goto jloop 			;Regresamos a jloop
END
	