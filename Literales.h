#ifndef LITERALES_HEADER
#define LITERALES_HEADER

typedef struct nodoLiteral NodoLiteral;

typedef struct listaLiteral ListaLiteral;

ListaLiteral * crearListaLiteral();

void agregarLiteral(ListaLiteral * lista, int posicion, char * dato);
void mostrarListaLiteral(ListaLiteral * lista);
void eliminarListaLiteral(ListaLiteral * lista);

#endif
