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
loop2 movlw h'80';		Pone valor 80 en WREG
 	movwf PORTB
	;call retardo;		Vamos a funcion retardo
 	movlw h'07';		Escribirmos 70 en WREG
	movwf contador;		WREG -> Contador

corrimiento: rrf PORTB,1;	Corimiento a la derecha de 1 en 1
	;call retardo
	decf contador;		Decrementa contador
	;call retardo
	btfss STATUS,Z;		Valor de Z en STATUS
	goto corrimiento;	Z = 0
	goto loop2;			Z != 0
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

; Para Ej3 y faltaria conversion a 1 segundo
; movlw h'FF'
; movwf PORTB
; call retardo
; clrf PORTB
; call retardo
; clrf PORTB