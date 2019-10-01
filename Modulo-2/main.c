#include <msp430.h> 
#include "msp430gpio.h"


int periodo(char cor);

/**
 * main.c
 */
int main(void)
{

	WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
	PM5CTL0 &= ~LOCKLPM5;
	
	int RED, GREEN, BLUE;
	long int timeStart, timeEnd, dif;
	setPin(P6_0, OUTPUT);
	setPin(P6_1, OUTPUT);
	setPin(P6_2, OUTPUT);
	setPin(P6_3, OUTPUT);
	setPin(P1_2, INPUT); // Receber os períodos

	while(readPin(P1_2) == HIGH); // Garantir que as leituras comecem na borda de subida

	while(1){
	    RED = periodo('V');
	    GREEN = periodo('G');
	    BLUE = periodo('B');
	}

	return 0;
}

int periodo(char cor){
    while(readPin(P1_2) == LOW); // Enquanto não tem borda de subida (período)

    switch(cor){
    // Seleciona a cor vermelha no sensor
    case 'V':
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

    for(int i=0; i<10; i++){ // Pega 10 leituras, ignorando as 2 primeiras
        if(i >= 2) {
            timeStart = timeEnd;
            timeEnd = PB0R;
            dif = timeEnd - timeStart;
        }
    }

    while(readPin(P1_2) == HIGH); // Enquanto não tem borda de subida (período)

    return int(dif/8) // Retorna a média dos períodos obtidos

}
