	processor 16f877
	include <p16f877.inc>
J equ H'26'
CONT equ H'27'
	ORG 0
	GOTO INICIO
	ORG 5
INICIO: movlw h'01';		Mueve a registro W el valor 01
		movwf J;			Mueve a J lo contenido en W
		movlw h'07';		Mueve a W el valor 07
		movwf CONT;			Mueve W a CONT

CORRIZQ:rlf J,1;			Corrimiento a la izquierda  
		decf CONT,1;		Decrementa CONT en 1
		btfss STATUS,2; 	Revisamos si b2 (Z) vale 1, vale 1 cuando una variable tenga VAL=0
			GOTO CORRIZQ; 	Z != 1 vamos a CORRIZQ
			GOTO INICIO; 	Z = 1 vamos a INICIO
END; 	FIN DE INSTRUCCIONES