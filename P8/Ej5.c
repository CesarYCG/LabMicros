// Encender todos las salidas del puerto B
#include <16f877.h>  //Incluir la biblioteca del pic
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232 (baud=38400, xmit=PIN_C6, rcv=PIN_C7) // Configurando COM serial asincrona
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)
// La com SERIAL YA ESTA establecida
char val1;
byte registro = 0x00;
int i;

void main(){
   while(1){
      printf("Indica num del 0 al 5 homs\n\r");
      val1 = getchar();
      if (val1 == '0'){ // LEDS APAGADOS 
         output_b(0x00);
      }else if (val1 == '1'){ // LEDS ENCEDIDOS
         output_b(0xff);
      }else if (val1 == '2'){ // Corrimiento derecha
         registro = 0x01; 
         output_b(registro);
         delay_ms(1000);
         for(i = 0; i <= 7; i++){
            registro = (registro << 1);
            output_b(registro);
            delay_ms(1000);
         }//For
      }else if (val1 == '3'){ // Corimiento izquierda
         registro = 0x80; 
         output_b(registro);
         delay_ms(1000);
         for(i = 0; i <= 7; i++){
            registro = (registro >> 1);
            output_b(registro);
            delay_ms(1000);
         }//For     
      }else if (val1 == '4'){ // Ambos corrimientos
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
         output_b(0xff);
         delay_ms(1000);
         output_b(0x00);
      }
      
   }//While
}//main

