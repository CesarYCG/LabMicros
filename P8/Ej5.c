#include <16f877.h>  //Incluir la biblioteca del pic
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232 (baud=38400, xmit=PIN_C6, rcv=PIN_C7) // Configurando COM serial asincrona
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)
// La com SERIAL YA ESTA establecida
char val1; // Variable para leer entradas
byte registro = 0x00; // Variable para guardar resultados
int i;      // Variable para iterar ciclos for
void main(){
   while(1){ // Siempre True
      printf("Indica num del 0 al 5 homs\n\r"); // mostramos el mensaje en el programa
      val1 = getchar(); // Leemos una entrada estandar
      if (val1 == '0'){ // LEDS APAGADOS 
         output_b(0x00);      // Apagamos todos los leds
      }else if (val1 == '1'){ // LEDS ENCEDIDOS
         output_b(0xff);
      }else if (val1 == '2'){ // Corrimiento derecha
         registro = 0x01;     // Encendemos el bit mas representativo
         output_b(registro);  // Lo mostramos en la salida del puerto B
         delay_ms(1000);      // Hacemos un delay de 1000[ms]
         for(i = 0; i <= 7; i++){ // En un ciclo for de 0 a 7
            registro = (registro << 1); // Utilizamos operador de corrimiento para mover el bit
            output_b(registro);   // Lo mostramos en la salida
            delay_ms(1000);      // Volvemos a dar un delay de 100ms
         }//For
      }else if (val1 == '3'){ // Corimiento izquierda
         registro = 0x80;  // Iluminamos bit menos significativo
         output_b(registro);  // Lo mostramos en la salida del puerto B
         delay_ms(1000);      // Hacemos un delay de 1000[ms]
         for(i = 0; i <= 7; i++){   // En un ciclo for de 0 a 7
            registro = (registro >> 1); // Utilizamos operador de corrimiento para mover el bit
            output_b(registro);  // Lo mostramos en la salida
            delay_ms(1000);    // Volvemos a dar un delay de 100ms
         }//For
      }else if (val1 == '4'){ // Ambos corrimientos, realizamos lo mismo que en 2 y 3
         registro = 0x01;  
         output_b(registro);
         delay_ms(1000);
         for(i = 0; i <= 7; i++){
            registro = (registro << 1);
            output_b(registro);
            delay_ms(1000);
         }//For
         registro = 0x80; 
         output_b(registro);
         delay_ms(1000);
         for(i = 0; i <= 7; i++){
            registro = (registro >> 1);
            output_b(registro);
            delay_ms(1000);
         }//For  
      }else if (val1 == '5'){ // Encender y apagar 
         output_b(0xff); // Encendemos todos los bits 
         delay_ms(1000); // Delay 1000ms
         output_b(0x00); // Apagamos todos los bits
      }
   }//While
}//main

