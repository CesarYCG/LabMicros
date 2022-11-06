;Práctica 3 - Ejercicio1

processor 16f877 				;Versión del procesador a utilizar
include <p16f877.inc> 			;Se cargan las librerias y el mapa de memoria

	J EQU 0X20 					;Localidades para la subrutina de retraso 
	K EQU 0X21 					;Se carga al vector RESET

	goto inicio 				;Su ubicación es en el espacio de memoria "inicio"
	org 5h 						;Se ubica en el espacio de memoria 5 

inicio:
	BSF STATUS, RP0 			;Nos posicionamos en el banco 1 para poder trabajar con TRIS
	BCF STATUS, RP1 			;Nos cambiamos al banco 1
	MOVLW 00H 					;Se configura al puerto A y E como analógico
	MOVWF ADCON1 				;Se coloca en ADCON1 para que todo se digital 
	MOVLW 00H 					;Ponemos al puerto B como una salida
	MOVWF TRISD 				;Se coloca en TRISB
	BCF STATUS, RP0 			;Retornamos al banco 0
	MOVLW b'11111001' 			;Frecuencia del reloj
	MOVWF ADCON0
	CLRF PORTD 					;Limpiamos el puertoB

CONVERTIDOR:
	BSF ADCON0, 2 				;Se inicia la conversión A/D modificando bit2 a 1
	CALL RETARDO 				;Llamamos a un retardo para que se haga la conversión
	BCF ADCON0, 2 				;Se finaliza la conversión 
	MOVFW ADRESH 				;Se lee el rediltado de la convresión 
	MOVWF PORTD 				;Se carga en el puerto B
	GOTO CONVERTIDOR 			;Regresamos a Convertidor 

RETARDO:
	MOVLW d'25' 				;w= 25 en decimal
	MOVWF J 					;J = w
jloop: 
	MOVWF K 					;K = w
kloop:
	DECFSZ K, f 				;Se hace un drecremento en 1 a k
	goto kloop 					;Regresamos a jloop
	DECFSZ J, f 				;Se decrementa en 1 a J
	goto jloop 					;Regresamos a jloop
END
	