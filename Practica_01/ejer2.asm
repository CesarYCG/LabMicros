	PROCESSOR 16f877 ; Indica la versión de procesador
	INCLUDE <p16f877.inc> ; Incluye la librería de la versión del procesador

J equ H'26'	;Se reserva un espacio para J especificamente el espaci 26 (ver mapa o banco de memoria)
K equ H'27' ;Se reserva un espacio para K especificamente el espaci 27
C1 equ H'28';Se reserva un espacio para K especificamente el espaci 28
R1 equ H'29';Se reserva un espacio para K especificamente el espaci 29
	ORG 0 ; Especifica un origen (vector de reset)
	GOTO INICIO ; Código del programa
	ORG 5 ; Indica origen para inicio del programa
INICIO: movf J,0 ; Mueve lo contenido en J hacia W
	addwf K,0 ; Se suma K con J y se guarda en W
	movwf R1 ;Mover el valor del registro W a R1
	btfsc STATUS,0;	Bloque if, si el bloque carry STATUS es 0
		goto ponuno; NO - Viajamos a ponuno
		clrf C1		; YES - BRINCA EL GOTO ANTERIOR y Limpia a C1 y vale 0
		goto INICIO; Volvemos a inicio
	ponuno: movlw h'01' ; Se asigna valor 1 al registro W
			movwf C1 ; Mover el valor de W (1) a  C1
			goto INICIO; repite el ciclo (salta a la etiquta LOOP)
END ; Directiva de fin de programa