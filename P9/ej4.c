#include <16f877.h>  //Incluir la biblioteca del pic
#device ADC=8, // Convertidor analogico digital con 8
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232(baud=38400,xmit=PIN_C6,rcv=PIN_C7) // Transmision rs232 C6 TRANS y C7 RECEP
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)

int var;

// Funcion de interrupcion
#int_rb  // Cambio de nivel de los PIN'S mas significativos
int_p(){

}//int_p()
