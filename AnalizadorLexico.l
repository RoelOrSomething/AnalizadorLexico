%{
/*
Primer proyecto: Analizador lexico de lenguaje propuesto.
Elaborado por Roel Alejandro Perez Candanoza.
Compiladores.
Semestre 2021-2.
*/

#include <stdio.h>
#include <stdlib.h>

#include "Tokens.h"
#include "Literales.h"
#include "Simbolos.h"
#include "FuncAux.h"

FILE *archSal;

/*Contador de lineas*/
int n_linea;

/*Contador de tablas*/
int n_tablaLitCadena;
int n_tablaLitDecimal;
int n_tablaSimbolo;

/*Creacion de tablas*/
ListaToken * tablaToken;
ListaLiteral * tablaLiteralCadena;
ListaLiteral * tablaLiteralDecimal;
ListaSimbolo * tablaSimbolo;

%}
/*Palabras reservadas*/
palres (DEC)|(ENT)|(MIENTRAS)|(PARA)|(SI)|(SINO)|(VAC)
/*Identificadores*/
ident [a-z][a-z0-9]*
/*Simbolos especiales*/
simesp ("{")|("}")|(",")|(";")|("(")|(")")|("[")|("]")
/*Cadenas*/
cadena @[^@]*@
/*Operadores aritmeticos*/
oparit (\+)|(-)|(\*)|(\/)
/*Operadores relacionales*/
oprel (#)|(==)|(>)|(>=)|(<)|(<=)
/*Constantes numericas enteras*/
entcte ([1-9][0-9]*)|0
/*Constantes numericas decimales*/
deccte {entcte}\.[0-9]+
/*Operador de asignacion*/
opasig (=)
%%
{cadena} { /* Reconoce una cadena */
			agregarLiteral(tablaLiteralCadena,n_tablaLitCadena,yytext);
			agregarToken(tablaToken,3,n_tablaLitCadena);
			n_tablaLitCadena++;
		}
{palres} { /* Reconoce una palabra reservada */
			agregarToken(tablaToken,0,indicePalabraReservada(yytext));
		}
{ident} { /* Reconoce un identificador */
			int i_ident = estaEnLaLista(tablaSimbolo,yytext);
			if(i_ident < 0){
				agregarSimbolo(tablaSimbolo,n_tablaSimbolo,yytext);
				agregarToken(tablaToken,1,n_tablaSimbolo);
				n_tablaSimbolo++;
			}
			else{
				agregarToken(tablaToken,1,i_ident);
			}
		}
{simesp} { /* Reconoce un símbolo especial */
			agregarToken(tablaToken,2,str2ascii(yytext));
		}
{oparit} { /* Reconoce un operador aritmetico */
			agregarToken(tablaToken,4,str2ascii(yytext));
			}
{oprel} { /* Reconoce un operador relacional */
			agregarToken(tablaToken,5,indiceOperadorRelacional(yytext));
		}
{deccte} { /* Reconoce una constante decimal */
			agregarLiteral(tablaLiteralDecimal,n_tablaLitDecimal,yytext);
			agregarToken(tablaToken,7,n_tablaLitDecimal);
			n_tablaLitDecimal++;
		}
{entcte} { /* Reconoce una constante entera */
			agregarToken(tablaToken,6,str2int(yytext));
		}
{opasig} { /* Reconoce un operador de asignacion */
			agregarToken(tablaToken,8,str2ascii(yytext));
		}
(\n) { /*Reconoce un salto de linea*/
	n_linea++;
	}
. { /*Reconoce un error lexico*/
	printf("Error lexico en linea %d: \"%s\"\n",n_linea,yytext);
	}
%%
void main(int argc, char * argv[])
{
	
	/*Contador de linea*/
	n_linea = 1;
	
	/*Contador de tablas*/
	n_tablaLitCadena = 0;
	n_tablaLitDecimal = 0;
	n_tablaSimbolo = 0;

	/*Creacion de tablas*/
	tablaToken = crearListaToken();
	tablaLiteralCadena = crearListaLiteral();
	tablaLiteralDecimal = crearListaLiteral();
	tablaSimbolo = crearListaSimbolo();

	yyin = fopen(argv[1],"r");
	archSal=fopen("salida.txt","w");
	yylex();
	fclose(archSal);
	
	printf("Tokens\n");
	mostrarListaToken(tablaToken);
	
	printf("Tabla de literales de cadenas\n");
	mostrarListaLiteral(tablaLiteralCadena);
	
	printf("Tabla de literales de decimales\n");
	mostrarListaLiteral(tablaLiteralDecimal);
	
	printf("Tabla de simbolos\n");
	mostrarListaSimbolo(tablaSimbolo);
	
	
	/*Se libera la memoria de las tablas*/
	eliminarListaToken(tablaToken);
	eliminarListaLiteral(tablaLiteralCadena);
	eliminarListaLiteral(tablaLiteralDecimal);
	eliminarListaSimbolo(tablaSimbolo);
}

