processor 16f877
include <p16f877.inc>

val equ h'20'
canal0 equ h'21'
canal1 equ h'22'
canal2 equ h'23'
final equ  h'24'

	org 0
	goto inicio
	org 5

inicio:
	clrf PORTA;			Limpia el puerto A
	clrf PORTD
	bcf STATUS,6
	bsf STATUS,5;		Se mueve al banco 1
	movlw 00H;			Configura puertos A y E  como analogico
	
	movwf ADCON1;		configuracion de ADCON1
	clrf TRISD;			limpia el puerto D
	bcf STATUS,5
	movlw b'11000001';	configuracion del como se trabaja, tiempo de oscilacion, canal0
	movwf ADCON0

leer:
	bsf ADCON0,2;		prende CAD
	call retardo
	
convierte:
	btfsc ADCON0,2;		brinca si el bit 2 de adcon0 es 0, es decir CAD apagado
	goto convierte;		va a subrutina convierte
	movf ADRESH,0;		Leemos el resultado de la conversion
	movwf canal0
	movlw b'11001001';	Configura el canal1 con la misma frecuencia
	movwf ADCON0;		que tenia el anterior, es decir la linterna
	bsf ADCON0,2;		prende CAD
	call retardo;		va a subrutina retardo

convierte2:
	btfsc ADCON0,2;		Brinca si el bit 2 de adcon0 es 0, es decir CAD apagado
	goto convierte2;	va a subrutina convierte2
	movf ADRESH,W;		mueve el resultado a W
	movwf canal1;		mueve lo que hay en w al canal1
	movlw b'11010001';	configura de nuevo la forma de trabajar
	movwf ADCON0;		esta vez sera el canal2
	bsf ADCON0,2;		prende CAD

convierte3:
	btfsc ADCON0,2;		Brinca si el bit2 de ADCON0 es 0, es decir CAD APAGADO
	goto convierte3;	va a subrutina convierte3
	movf ADRESH,W;		mueve el resultado a w
	movwf canal2;		Mueve lo de w al canal2
	movlw b'11011001';	mueve el 'codigo' para configurar el canal3, a w
	movwf ADCON0;		Mueve lo de w a ADCON0
	bsf ADCON0,2;		Prende CAD	
	call retardo;		vamos a retardo

canal:
	movf canal0,W;		mueve canal0 a w
	subwf canal1,W;		resta canal1 con lo que hay en w(canal0)
	btfss STATUS,1;		salta si el bit 1 de status esta en 1, es decir, existe el medio carry
	btfsc STATUS,1;		salta si el bit 1 de estatus esta en 0, no existe medio carry
	goto canalCero;		va a subrutina canalCero
	goto canalUno;		va a subrutina canalUno

canalCero:
	movf canal0,W;		mueve canal0 a w
	subwf canal2,W;		resta lo que hay en w(canal0) con el canal2
	btfss STATUS,1;		brinca si existe un medio carry
	goto canalDos;		vamos a subr canalDos
	goto Mando0;		vamos a Mando0

canalUno:
	movf canal1,W;		mueve canal1 a w
	subwf canal2,W;		resta lo que hay en w(canal0) con el canal2
	btfss STATUS,1;		brinca si existe un medio carry
	goto canalDos;		vamos a subr canalDos
	goto Mando1;		vamos a Mando1

canalDos:
	movlw h'07';		Mueve h07 a w
	movwf PORTD;		Mueve w -> PORTD
	goto leer;			vamos a subr leer

Mando0:
	movlw h'03';		Mueve h03 a w
	movwf PORTD;		Mueve w -> PORTD
	goto leer;			vamos a subr leer	

Mando1:
	movlw h'01';		Mueve h03 a w
	movwf PORTD;		Mueve w -> PORTD
	goto leer;			vamos a subr leer	

retardo:
	movlw h'30'
	movwf val

loop:
	decfsz val,1
	goto loop
	return

end
