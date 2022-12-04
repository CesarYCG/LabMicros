#include <16f877.h>  //Incluir la biblioteca del pic
#device ADC=8, // Convertidor analogico digital con 8
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232(baud=38400,xmit=PIN_C6,rcv=PIN_C7) // Transmision rs232 C6 TRANS y C7 RECEP
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)

int var1;

// Funcion de interrupcion
#int_rb // Cambio de nivel en los PIN's mas significativos
int_p(){
	if (input(pin_b4)){
		printf("\nPB4 activado");
	}else
		printf("\nPB4 desactivado");

	if (input(pin_b5)){
		printf("\nPB5 activado");
	}else
		printf("\nPB5 desactivado");

	if (input(pin_b6)){
		printf("\nPB6 activado");
	}else
		printf("\nPB6 desactivado");

	if (input(pin_b7)){
		printf("\nPB7 activado");
	}else
		printf("\nPB7 desactivado");

	print("\n\n--------------------------------\n\n");
}

void main(){
	setup_counters(RTCC_INTERNAL,RTCC_DIV_256); /FUENTE RELOJ
	enable_interrupts(INT_RB); // INTERRUPCION PÓR TIMER
	enable_interrupts(GLOBAL); // interrupciones generales
	while(1){
		var1=input_b();
		output_a(var1);
	}
}//main