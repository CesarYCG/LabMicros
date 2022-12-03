#include <16f877.h>  //Incluir la biblioteca del pic
#device ADC=8, // Convertidor analogico digital con 8
#fuses HS, NOPROTECT, // Configuración serie asincrona
#use delay(clock=20000000) //Valor del cristal con el que trabajamos para calcular el retardo
#use rs232(baud=38400,xmit=PIN_C6,rcv=PIN_C7) // Transmision rs232 C6 TRANS y C7 RECEP
#org 0x1f00, 0x1FFF void loader16f877(void){} // Vector de SET (simpre se usa para compilar)

int conv;
long cont=0;   //Contador para activar la interrupcion

// Funcion de interrupcion
#int_RTCC
clock_isr(){
   cont++; // Incrementa contador
   // Determinamos 30 segundos
   if(cont==763*3){
      printf("Laboratorio de microcomputadoras\n");
      cont=0;
   }//if
}//clock_isr

void main(){
   set_timer0(0);
   setup_counters(RTCC_INTERNAL,RTCC_DIV_256); // Fuente reloj y predivisor
   enable_interrupts(INT_RTCC);  // Habilita interrupcion para timer0
   enable_interrupts(GLOBAL); // Habilita interrupciones generales
   setup_adc_ports(ALL_ANALOG);
   setup_adc(ADC_CLOCK_INTERNAL);
   set_adc_channel(7);
   while(1){
      delay_ms(2000); // 20ms retardo
      conv=read_adc();
      printf("El resultado es:=%x\n",conv); // Imprimimos
      output_D(conv);   // SAlida en puerto D
   }//while
}//main

