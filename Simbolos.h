#ifndef SIMBOLOS_HEADER
#define SIMBOLOS_HEADER

typedef struct nodoSimbolo NodoSimbolo;

typedef struct listaSimbolo ListaSimbolo;

ListaSimbolo * crearListaSimbolo();

void agregarSimbolo(ListaSimbolo * lista, int posicion, char * nombre);
void mostrarListaSimbolo(ListaSimbolo * lista);
int estaEnLaLista(ListaSimbolo * lista, char * nombre);
void eliminarListaSimbolo(ListaSimbolo * lista);

#endif
