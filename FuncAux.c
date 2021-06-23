#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "FuncAux.h"

/*Catalogo de palabras reservadas*/
char palResCat[7][9] = {
						"DEC",
						"ENT",
						"MIENTRAS",
						"PARA",
						"SI",
						"SINO",
						"VAC"};

/*Catalogo de operadores relacionales*/
char opRelCat[6][3] = {
						"#",
						"==",
						">",
						">=",
						"<",
						"<="};

// Metodo que devuelve el indice de la palabra reservada en el catalogo
int indicePalabraReservada(char * palabra){
	for(int i = 0; i < 7; i++){
		if (!strcmp(palabra,palResCat[i]))
			return i;
	}
	return -1;
}

// Metodo que devuelve el indice del operador relacional en el catalogo
int indiceOperadorRelacional(char * palabra){
	for(int i = 0; i < 6; i++){
		if (!strcmp(palabra,opRelCat[i]))
			return i;
	}
	return -1;
}

// Metodo que convierte apuntador a cadena a valor entero de ASCII
int str2ascii(char * str){
	int str_ascii = *str;
	return str_ascii;
}

// Metodo que convierte apuntador a cadena a entero
int str2int(char * str){
	int str_int = atoi(str);
	return str_int;
}