;Práctica 3 - Ejercicio2

processor p16f877 				;Versión del procesador a utilizar
include <p16f877.inc> 			;Se cargan las librerias y el mapa de memoria

	J EQU 0X20 					;Localidades para la subrutina de retraso 
	K EQU 0X21 					;Se carga al vector RESET
	
	goto INICIO 				;Su ubicación es en el espacio de memoria "inicio"
	org 5h 						;Se ubica en el espacio de memoria 5 

INICIO:
	CLRF PORTA 					;limpiamos PORTA
	BSF STATUS, RP0 			;Nos posicionamos en el banco 1 para poder trabajar con TRIS
	BCF STATUS, RP1 			;Nos cambiamos al banco 1
	MOVLW 00H 					;Se configura al puerto a y e como analógico
	MOVWF ADCON1 				;Se coloca en ADCON1 para que todo se digital 
	MOVLW 00H 					;Ponemos al puerto B como una salida
	MOVWF TRISD 				;Se coloca en TRISD
	BCF STATUS, RP0 			;Retornamos al banco 0
	MOVLW b'11111001' 			;Frecuencia del reloj
	MOVWF ADCON0
	CLRF PORTD 					;Limpiamos el puertoB

CONVERTIDOR:
	;BCF STATUS, C 				;Se limpia a C
	BSF ADCON0, 2 				;Se inicia la conversión de a/d
	CALL RETARDO 				;Se llama un retardo
	BCF ADCON0,2 				;Se finaliza la conversión 
	MOVFW ADRESH 				;Se lee el ediltado de la conversión
	SUBLW D'85' 				;Se resta el primer tercio
	BTFSC STATUS, C 			;El carry se apaga si es negativo
	GOTO OP1 					;Si es positivo se va a la op1
	MOVFW ADRESH 				;Se lee el resultado de la conversión 
	SUBLW D'170' 				;Se resta el segundo tercio
	BTFSC STATUS, C 			;Si el carry se apaga si el resultado es negativo
	GOTO OP2 					;Pero si es positivo se va a la op1
	MOVLW H'07' 				;Si no es ninguna de las anteriores es porque esta en el tercer caso
	MOVWF PORTD 				;Se pone en el puertob
	GOTO CONVERTIDOR 			;Se vuelve a INICIO
	
OP1: 
	MOVLW H'01' 			;Se pone un 1 en el puerto B
	MOVWF PORTD
	GOTO CONVERTIDOR
	
OP2:
	MOVLW H'03' 			;Se pone un 3 en el puerto B
	MOVWF PORTD 
	GOTO CONVERTIDOR 

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
	RETURN
END