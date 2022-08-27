	PROCESSOR 16f877 ; Indica la versión de procesador
	INCLUDE <p16f877.inc> ; Incluye la librería de la versión del procesador

K equ H'26'	;Se reserva un espacio para K especificamente el espaci 26 (ver mapa o banco de memoria)
L equ H'27' ;Se reserva un espacio para L especificamente el espaci 27
	ORG 0 ; Especifica un origen (vector de reset)
	GOTO INICIO ; Código del programa
	ORG 5 ; Indica origen para inicio del programa
INICIO: movlw h'05' ;Mueve un 5 en el registro W
	addwf K,0 ;Se suma W con K y 0 indica que el resultado de la suma se guarda en el registro W
	movwf L ;Mover el valor del registro W a L
GOTO INICIO ; repite el ciclo (salta a la etiqueta LOOP)
END ; Directiva de fin de programa