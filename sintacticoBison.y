
%{

#include <stdio.h>
#include <stdlib.h> 
int yylex();
int yyerror(char*);

struct {
    char* nombre;
    int valor;
}Variable;

struct Nodo{
    Variable info;
    Nodo*sig;
}

Nodo lista = NULL;

%}

%token ASIGNACION PUNTO SUMA RESTA PARENTESISIZQUIERDO PARENTESISDERECHO COMA OTHER ID NUMERO CALCULARFECHA CALCULAREDAD MOSTRAREDAD INICIO FIN ENTERO

%union{
   char cadena[30];
   int number;
   char* reservada;
} 

%type <cadena> ID
%type <number> NUMERO EXPRESION PRIMARIA
%type <reservada> MOSTRAREDAD CALCULARFECHA CALCULAREDAD INICIO FIN ENTERO

%%

prog: 
    INICIO SENTENCIAS FIN
;

SENTENCIAS: SENTENCIA SENTENCIAS  
        | SENTENCIA
;

SENTENCIA: ENTERO ID PUNTO {asignarValorA($2, 0);}
        | ENTERO ID ASIGNACION NUMERO PUNTO { asignarValorA($2, $4); }
        | ID ASIGNACION EXPRESION PUNTO { cambiarValorA($1, $3); }
        | ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO NUMERO COMA NUMERO COMA NUMERO PARENTESISDERECHO PUNTO { asignarValorA($1, calcularFecha($5, $7, $9)); } // SI ME DAN 3 NUMEROS
        | ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO NUMERO COMA NUMERO PARENTESISDERECHO PUNTO { asignarValorA($1, calcularEdad($5, $7)); } // SI ME DAN 2 NUMEROS
        | ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO ID COMA ID COMA ID PARENTESISDERECHO PUNTO { asignarValorA($1, calcularFecha(buscar(lista, $5)->info.valor, buscar(lista, $7)->info.valor, buscar(lista, $9)->info.valor)); } // SI ME DAN 3 IDENTIFICADORES
        | ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO ID COMA ID PARENTESISDERECHO PUNTO { asignarValorA($1, calcularEdad(buscar(lista, $5)->info.valor, buscar(lista, $7)->info.valor)); } // SI ME DAN 2 IDENTIFICADORES
        | MOSTRAREDAD PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO { mostrarEdad(buscar(lista, $3)->info.valor) }
;


EXPRESION: PRIMARIA {$$ = $1; }
        | EXPRESION SUMA PRIMARIA { $$ = $1 + $3; }
        | EXPRESION RESTA PRIMARIA { $$ = $1 - $3; }
; 

PRIMARIA: ID { $$ = (buscar(lista, $1)->info.valor); }
        |NUMERO { $$ = $1 ; }
        |PARENTESISIZQUIERDO EXPRESION PARENTESISDERECHO { $$ = $2; }
;

%%

int yyerror(char *s)
{
	printf(" -> Error sintactico en %s\n", s);
	return 0;
}

int main(int argc, char **argv)
{
    yyparse();
    return 0;
}

int calcularEdad(int fechaActual, int fechaNacimiento) {
    int dia_a = fechaActual % 100;
    int mes_a = (fechaActual % 10000 - dia_a) / 100;
    int anio_a = fechaActual / 10000;
    int dia_n = fechaNacimiento % 100;
    int mes_n = (fechaNacimiento % 10000 - dia_n) / 100;
    int anio_n = fechaNacimiento / 10000;

    int edad_a = anio_a - anio_n;
    int edad_m = mes_a - mes_m;
    int edad_d = dia_a - dia_n;
    int aux;
    
    if(edad_m < 0) {
        edad_a--;
        aux = 12 - edad_m;
        edad_m = aux;
    }

    if(edad_d < 0) {
        edad_m--;
        aux = 30 - edad_d;
        edad_d = aux;
    }
    return edad_a * 10000 + edad_m * 100 + edad_d 
}

void mostrarEdad ( int edad){
    int edad_d = edad % 100;
    int edad_m = (edad % 10000 - edad_d) / 100;
    int edad_a = edad / 10000;

    printf("Usted tiene %s años, %s meses y %s dias\n", edad_a, edad_m, edad_d);
}

int calcularFecha(int anio, int mes, int dia){
    return anio * 10000 + mes * 100 + dia
}

void asignarValorA(char* unIdentificador, int unValor) {
    Variable aux;
    aux.nombre = unIdentificador;
    aux.valor = unValor;
    insertar(lista, aux);
}

void cambiarValorA(char* unIdentificador, int unValor) {
    Variable aux;
    aux.nombre = unIdentificador;
    aux.valor = unValor;
    reemplazarEn(lista, unIdentificador, unValor);
}

void insertar(Nodo*&lista,Variable var)
{
    Nodo *n,*p,*ant;
    n=new Nodo;
    n->info=var;
    p=lista;
    while(p!=NULL)
    {
        ant=p;
        p=p->sig;
    }
    n->sig=p;
    if(p!=lista)
        ant->sig=n;
    else
        lista=n;
}

void reemplazarEn(Nodo*lista,char* unIdentificador, int unValor)
{
    
    Nodo*objetivo=buscar(lista, unIdentificador);
    if(objetivo == NULL)
        cout<<"no existe un identificador con nombre"<<endl;
    else
        objetivo->info.valor = unValor;
}

Nodo*buscar(Nodo*lista, char* unIdentificador)
{
    Nodo*p=lista;
    while(p!=NULL && p->info.nombre != unIdentificador)
        p=p->sig;
    return p;
}