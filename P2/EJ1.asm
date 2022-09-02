processor 16f877
include<p16f877.inc>
	contador equ h'20'
	valor1 equ h'21'
	valor2 equ h'22'
	valor3 equ h'23'
	cte1 equ 20h
	cte2 equ 50h
	cte3 equ 60h
org 0
	goto inicio
org 5
inicio bsf STATUS,5;	Cambiamos Registro RP0 Para Banco1
	BCF STATUS,6;		Cambiamos Registro RP1 Para Banco1
 	MOVLW H'0';			Colocamos el 0 en el registro WREG
 	MOVWF TRISB;		Ponemos el regisro TRISB en 0
 	BCF STATUS,5;		Regresamos al Banco0
 	clrf PORTB;			Limpiamos el registro PORTB
loop2 bsf PORTB,0;		Pone en 1 el bit0 de PORTB
 	call retardo;		Vamos a funcion retardo
 	bcf PORTB,0;		Ponemos en 0 el bit0 de PORTB
 	call retardo;		Funcion retardo
 	goto loop2;			Vamos a loop2
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
END