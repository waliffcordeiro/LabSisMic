#include <msp430.h> 
#include "msp430gpio.h"


int periodo(char cor);

/**
 * main.c
 */
int main(void)
{

	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	TB0CTL = TBSSEL__SMCLK | MC__CONTINOUS; // Timer
	PM5CTL0 &= ~LOCKLPM5; // Ativar os pinos (desabilitar modo de alto impedância)
	
	volatile int RED, GREEN, BLUE;

	setPin(P6_0, OUTPUT);
	setPin(P6_1, OUTPUT);
	setPin(P6_2, OUTPUT);
	setPin(P6_3, OUTPUT);
	setPin(P1_2, INPUT); // Receber os períodos
	// Set LED
	setPin(P1_0, OUTPUT);
	setPin(P6_6, OUTPUT);

	while(readPin(P1_2) == HIGH); // Garantir que as leituras comecem na borda de subida

	while(1){
	    RED = periodo('R');
	    GREEN = periodo('G');
	    BLUE = periodo('B');

	    if((RED < BLUE) && (RED < GREEN)){
	        // Acende Vermelho
            writePin(P1_0, HIGH);
            writePin(P6_6, LOW);
	    }
	    else if((BLUE < RED) && (BLUE < GREEN)){
            // Acende Azul
	        writePin(P1_0, HIGH);
	        writePin(P6_6, HIGH);
        }
        else if((GREEN < RED) && (GREEN < BLUE)){
            // Acende Verde
            writePin(P1_0, LOW);
            writePin(P6_6, HIGH);
        }
	}

	return 0;
}

int periodo(char cor){
    int i, periodo = 0;
    unsigned int timeStart = 0, timeEnd = 0;
    long int dif = 0;

    switch(cor){
    // Seleciona a cor vermelha no sensor
    case 'R':
        writePin(P6_2, LOW);
        writePin(P6_3, LOW);
        break;
    // Seleciona a cor azul no sensor
    case 'B':
        writePin(P6_2, LOW);
        writePin(P6_3, HIGH);
        break;
    // Seleciona a cor verde no sensor
    case 'G':
        writePin(P6_2, HIGH);
        writePin(P6_3, HIGH);
        break;
    }

    for(i=0; i<10; i++) { // Pega 10 leituras, ignorando as 2 primeiras
        while(readPin(P1_2) == LOW); // Enquanto não tem borda de descida (período)
        timeStart = timeEnd;
        timeEnd = TB0R;
        if(i >= 2) {
            dif = (timeEnd - timeStart);
            if(dif < 0) {
                dif += 0xFFFF;
                dif += 1;
            }
            periodo += dif;
        }
        while(readPin(P1_2) == HIGH); // Enquanto não tem borda de subida (período)
    }

    periodo = ((int)(periodo/8));
    return periodo; // Retorna a média dos períodos obtidos

}
