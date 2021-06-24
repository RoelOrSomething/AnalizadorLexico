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

FILE *archivo_salida;

/*Contador de lineas*/
int n_linea;

/*Contador de tablas*/
int n_tablaLitCadena;
int n_tablaLitDecimal;
int n_tablaSimbolo;

/*Declaracion de tablas*/
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
cadena @.*@
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

	/*El nombre del archivo de entrada*/
	char * nom_arch = (char *) malloc(strlen(argv[1])+1);
	strcpy(nom_arch,argv[1]);

	/*Lee del archivo y ejecuta yylex*/
	yyin = fopen(nom_arch,"r");
	yylex();
	
	/*Despeja el archivo de salida y lo abre en modo append*/
	char * nom_arch_salida = strcat(nom_arch,".lex");
	fclose(fopen(nom_arch_salida, "w"));
	archivo_salida=fopen(nom_arch_salida,"a");
	
	/*Muetra tabla de simbolos en consola y en archivo*/
	printf("\nTabla de simbolos\n");
	mostrarListaSimbolo(tablaSimbolo);
	fprintf(archivo_salida,"\nTabla de simbolos\n");
	imprimirAArchivoListaSimbolo(tablaSimbolo,archivo_salida);
	
	/*Muestra tabla de literales de cadena en consola y en archivo*/
	printf("\nTabla de literales de cadenas\n");
	mostrarListaLiteral(tablaLiteralCadena);
	fprintf(archivo_salida,"\nTabla de literales de cadenas\n");
	imprimirAArchivoListaLiteral(tablaLiteralCadena,archivo_salida);
	
	/*Muestra tabla de literales de decimales en consola y en archivo*/
	printf("\nTabla de literales de decimales\n");
	mostrarListaLiteral(tablaLiteralDecimal);
	fprintf(archivo_salida,"\nTabla de literales de decimales\n");
	imprimirAArchivoListaLiteral(tablaLiteralDecimal,archivo_salida);
	
	/*Muestra tokens en consola y en archivo*/
	printf("\nTokens\n");
	mostrarListaToken(tablaToken);
	fprintf(archivo_salida,"\nTokens\n");
	imprimirAArchivoListaToken(tablaToken,archivo_salida);
	
	printf("\n");
	fprintf(archivo_salida,"\n");
	
	fclose(archivo_salida);
	
	/*Se libera la memoria de las tablas*/
	eliminarListaToken(tablaToken);
	eliminarListaLiteral(tablaLiteralCadena);
	eliminarListaLiteral(tablaLiteralDecimal);
	eliminarListaSimbolo(tablaSimbolo);
}

