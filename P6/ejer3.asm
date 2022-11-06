;Práctica 3 - Ejercicio3
;					PORTD
; Ve5 > Ve6 y Ve7 -> 001
; Ve6 > Ve5 y Ve7 -> 011
; Ve7 > Ve5 y Ve6 -> 111

processor p16f877 ;Versión del procesador a utilizar
include <p16f877.inc> ;Se cargan las librerias y el mapa de memoria

	J EQU 0X20 						;Localidades para la subrutina de retraso 
	K EQU 0X21 						;Se carga al vector RESET
	
	;Variables para los canales
	CANAL5 EQU H'24' 				;Canal 1 en la localidad 24
	CANAL6 EQU H'25' 				;Canal 2 en la localidad 25
	CANAL7 EQU H'26' 				;Canal 3 en la localidad 26
	 
	org 0h 
	goto INICIO 					;Su ubicación es en el espacio de memoria "inicio"
	org 5h 							;Se ubica en el espacio de memoria 5 

INICIO:
	CLRF PORTA 						;Limpiamos el puerto A
	BSF STATUS, RP0 				;Nos posicionamos en el banco 1 para poder trabajar con TRIS
	BCF STATUS, RP1 				;Nos cambiamos al banco 1
	MOVLW 00H 						;Se configura al puerto a y e como analógico
	MOVWF ADCON1 					;Se coloca en ADCON1 para que todo se digital 
	MOVLW 00H						;Ponemos al puerto D como una salida
	MOVWF TRISD 					;Se coloca en TRISD
	BCF STATUS, RP0 				;Retornamos al banco 0
	MOVLW b'11111001' 				;Frecuencia del reloj
	MOVWF ADCON0
	CLRF PORTD 						;Limpiamos el puertoD

CONVERTIDOR:
	BSF ADCON0, 2 					;Se inicia la conversión de a/d
	CALL RETARDO 					;Se llama un retardo
	BCF ADCON0,2 					;Se finaliza la conversión 
	MOVF ADRESH,0 					;Se lee el ediltado de la conversión
	MOVWF CANAL7 					;Se guarda el primer valor
	MOVLW b'11110001' 				; Frecuencia de reloj, convertidor a/d
	MOVWF ADCON0
	BSF ADCON0,2
	CALL RETARDO
	BCF ADCON0, 2 					;Se limpia el carry 
	MOVF ADRESH,0 					; Se inicia la conversión de a/d
	MOVWF CANAL6

	MOVLW b'11101001' 				; Frecuencia de reloj, convertidor a/d
	MOVWF ADCON0
	BSF ADCON0,2 					; Se inicia la conversión de a/d
	CALL RETARDO 					;Se llama un retardo 
	BCF ADCON0,2 					;Se finaliza la conversión
	MOVF ADRESH,0 					;Se lee el resultado de la conversión 
	MOVWF CANAL5					;Se guarda el tercer valor

	;movf CANAL1, e 				;Nos movemos a canal1 en W
	;SUBWF CANAL2 					;Se hace la resta de CANAL2-CANAL1 y se guarda en W
	;BTFSC STATUS, C 				;Carry se apaga si el resultado es negativo 
	;GOTO OP2 						;Entonces V2>V1
	;GOTO P1 						;Entonces comparamos si V6>V5
CANAL: 
	MOVF CANAL5, w 				;Se mueve canal1 en w
	SUBWF CANAL6,w 				;Se resta CANAL3-CANAL1 y se guarda en W
	BTFSS STATUS, 1 			;Carry se apaga si el resultado es negativo 
	BTFSC STATUS, 1
	GOTO CANALCINCO 				;Entonces V1>V3 
	GOTO CANALSEIS 				;Entonces comparamos si V6>V5

CANALCINCO:
	MOVF CANAL5, w 				;Se mueve canal2 en w
	SUBWF CANAL7,w 				;Se resta CANAL3-CANAL2 y se guarda en W
	BTFSS STATUS, 1 			;Carry se apaga si el resultado es negativo 
	GOTO CANALSIETE 				;Entonces V1>V3 
	GOTO Mando1 				;Entonces V3>V1

CANALSEIS:
	MOVF CANAL6,w 				;Se coloca un 1 en el puerto D
	SUBWF CANAL7,w 				;Se carga en el puerto D
	BTFSS STATUS, 1 			;Carry se apaga si el resultado es negativo 
	GOTO CANALSIETE 				;Entonces V5>V7 
	GOTO Mando0 				;Entonces V6>V5	

CANALSIETE:
	MOVLW H'07' 				;Se coloca un 1 en el puerto D
	MOVWF PORTD 				;Se carga en el puerto D
	goto CONVERTIDOR
	
Mando0:
	MOVLW H'03' 				;Se coloca un 3 en el puerto D
	MOVWF PORTD 				;Se carga en el puerto D
	goto CONVERTIDOR

Mando1:
	MOVLW H'01' 				;Se coloca un 1 en el puerto D
	MOVWF PORTD 				;Se carga en el puerto D
	goto CONVERTIDOR

RETARDO:
	MOVLW d'25' 					;w= 25 en decimal
	MOVWF J 						;J = w
jloop: 
	MOVWF K 						;K = w
kloop:
	DECFSZ K, f 					;Se hace un drecremento en 1 a k
	goto kloop 						;Regresamos a jloop
	DECFSZ J, f 					;Se decrementa en 1 a J
	goto jloop 						;Regresamos a jloop
END