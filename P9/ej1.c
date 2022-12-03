#include <16f877.h>  //Incluir la biblioteca del pic
#device ADC=8, // Convertidor analogico digital con 8
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232(baud=38400,xmit=PIN_C6,rcv=PIN_C7) // Transmision rs232 C6 TRANS y C7 RECEP
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)
int converse;

void main(){
   setup_adc_ports(ALL_ANALOG); // Todos los puertos analogicos (PORTA y PORTE)
   setup_adc(ADC_CLOCK_INTERNAL); //ADCON0 trabajando con oscilador interno
   set_adc_channel(7); // Habilita el CANAL
   
   while(1){
      delay_ms(20);  //Retardo de 20 ms
      converse=read_adc();    // Guardamos conversion en converse
      printf("El resultado es:=%x\n",converse); // Imprimimos converse
      output_D(converse);  // Mostramos el resultado en el puerto B
   }//while
}//main
