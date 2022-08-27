	processor 16f877
	include <p16f877.inc>
J equ H'26'
CONT equ H'27'
	ORG 0
	GOTO INICIO
	ORG 5
INICIO: movlw d'00';		Mueve a registro W el valor 01
		movwf J;			Mueve a J lo contenido en W
		movlw d'20';		Mueve a W el valor 07
		movwf CONT;			Mueve W a CONT

CONTADOR:incf J,1;			Incrementa J en 1  
		decf CONT,1;		Decrementa CONT en 1
		btfss STATUS,2; 	Revisamos si b2 (Z) vale 1
			GOTO CONTADOR; 	Z != 1 vamos a CORRIZQ
			GOTO INICIO; 	Z = 1 vamos a INICIO
END; 	FIN DE INSTRUCCIONES