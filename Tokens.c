#include <stdio.h>
#include <stdlib.h>
#include "Tokens.h"

// Estructura del token
struct nodoToken {
	int clase; // Clase
	int valor; // Valor
	struct nodoToken * next; // Siguiente token
};

// Lista de Tokens
struct listaToken {
	NodoToken * head; // Primer elemento
	NodoToken * tail; // Ultimo elemento
};

// Método para crear un nodo de token
NodoToken * crearToken(int clase, int valor);

NodoToken * crearToken(int clase, int valor){
	NodoToken * nuevoNodo = malloc(sizeof(NodoToken));
	if (!nuevoNodo) {
		return NULL;
	}
	nuevoNodo->clase = clase;
	nuevoNodo->valor = valor;
	nuevoNodo->next = NULL;
	return nuevoNodo;
}

// Metodo para crear una lista de tokens
ListaToken * crearListaToken();

ListaToken * crearListaToken(){
	ListaToken * lista = malloc(sizeof(ListaToken));
	if (!lista) {
		return NULL;
	}
	lista->head = NULL;
	lista->tail = NULL;
	return lista;
}

// Metodo para mostrar el contenido de una lista de tokens
void mostrarListaToken(ListaToken * lista) {
	NodoToken * current = lista->head;
	if(lista->head == NULL) 
		return;
  	for(; current != NULL; current = current->next) {
		printf("(%d,%d)\n", current->clase,current->valor);
	}
}

// Metodo para agregar un token a la lista
void agregarToken(ListaToken * lista, int clase, int valor){
	NodoToken * current = NULL;
	if(lista->head == NULL){
		lista->head = crearToken(clase,valor);
		lista->tail = lista->head;
	}
	else {
		current = lista->tail;
		current->next = crearToken(clase,valor);
		lista->tail = current->next;
	}
}

// Metodo para eliminar la lista de tokens
void eliminarListaToken(ListaToken * lista){
	NodoToken * current = lista->head;
	NodoToken * next = current;
	while(current != NULL){
		next = current->next;
		free(current);
		current = next;
	}
	free(lista);
}
