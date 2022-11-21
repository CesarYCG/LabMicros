#include <16f877.h>  //Incluir la biblioteca del pic
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)
void main(){
   while(1){   //(Bucle infinito)
      output_b(0x01);   //(Puerto B de salida) se enciende el puerto    
      delay_ms(1000);   //Retardo de mil milisegundos
      output_b(0x00);   //Se apaga el puerto
      delay_ms(1000);   //Retardo de mil milisegundos
   }  //while
}  //main

//Pasos en emsablador
// 1. Cambio banco 1
// 2. Configuro TRISB=h'00'
// 3. Regreso banco 0
// 4. Asigna valores PORTB h'01' o h'00'
// Poner que hace el programa a nivel a emsablador 
