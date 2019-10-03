#include <msp430.h> 
#include "msp430gpio.h"


// Gabriel Porto Oliveira - 18/0058975
// Waliff Cordeiro Bandeira - 17/0115810

int periodo(char cor);

/**
 * main.c
 */
int main(void)
{

	WDTCTL = WDTPW | WDTHOLD;	     // stop watchdog timer
	TB0CTL = TBSSEL__SMCLK | MC__CONTINOUS; // Timer
	PM5CTL0 &= ~LOCKLPM5;            // Ativar os pinos (desabilitar modo de alto impedância)
	
	unsigned int RED, GREEN, BLUE;

	setPin(P6_0, OUTPUT);            // S0 - Select Freq.
	setPin(P6_1, OUTPUT);            // S1 - Select Freq.
	setPin(P6_2, OUTPUT);            // S2 - Select Color
	setPin(P6_3, OUTPUT);            // S3 - Select Color
	setPin(P1_2, INPUT);             // OUT do sensor de cor
	setPin(P1_0, OUTPUT);            // Led vermelho
	setPin(P6_6, OUTPUT);            // Led verde

	writePin(P6_0, HIGH);            // Selecionando frequência de 20% - 5 Leituras
	writePin(P6_1, LOW);

	while(readPin(P1_2) == HIGH);    // Garantir que as leituras comecem na borda de subida

	while(1){
	    RED = periodo('R');
	    GREEN = periodo('G');
	    BLUE = periodo('B');

	    if((RED < BLUE) && (RED < GREEN)){
	        // Acende Vermelho
            writePin(P1_0, HIGH);
            writePin(P6_6, LOW);
	    }
        else if((GREEN < RED) && (GREEN < BLUE)){
            // Acende Verde
            writePin(P1_0, LOW);
            writePin(P6_6, HIGH);
        }
	    else if((BLUE < RED) && (BLUE < GREEN)){
            // Acende ambos
            writePin(P1_0, HIGH);
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

    for(i=0; i<25; i++) {                 // Pega 25 leituras, ignorando as 2 primeiras
        while(readPin(P1_2) == LOW);      // Enquanto não tem borda de descida (período)
        timeStart = timeEnd;              // Time anterior
        timeEnd = TB0R;                   // Time atual
        if(i >= 2) {
            dif = (timeEnd - timeStart);
            if(dif < 0) {                 // Se for tempo negativo, soma a correção
                dif += 0xFFFF;
                dif += 1;
            }
            periodo += dif;               // O período será a soma de todas leituras
        }
        while(readPin(P1_2) == HIGH);     // Enquanto não tem borda de subida (período)
    }

    return periodo;                       // Retorna a média dos períodos obtidos

}
