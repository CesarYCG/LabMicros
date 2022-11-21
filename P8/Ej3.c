// Encender todos las salidas del puerto B
#include <16f877.h>  //Incluir la biblioteca del pic
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)

int var1;
void main(){
   while (1){ // Ciclo constante
      var1 = input_a(); // Leemos una entrada
      output_b(var1);  // Esa entrada se vuelve la salida 
   } // while
} // main
