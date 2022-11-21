// Encender todos las salidas del puerto B
#include <16f877.h>  //Incluir la biblioteca del pic
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232 (baud=38400, xmit=PIN_C6, rcv=PIN_C7) // Configurando COM serial asincrona
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)
// La com SERIAL YA ESTA establecida

void main(){
   while(1){
      output_b(0xff);
      printf("Todos los bits encendidos \n\r");
      delay_ms(1000);
      output_b(0x00);
      printf("Todos los leds apagados \n\r");
      delay_ms(1000);
   }//While
}//main

// Recibimos entrada
// Imprimimos mensajes

