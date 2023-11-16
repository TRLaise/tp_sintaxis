/* desconozco como hacer las sumas, restas, operaciones y demas, se que tienen que delegarse a lenguaje C, pero falta investigar*/
%{

#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern int yyerror(char*);

int dia_a=0;
int mes_a=0;
int anio_a=0;
int dia_n=0;
int mes_n=0;
int anio_n=0;

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

%union{
   char* cadena;
   int num;
} 

%token ASIGNACION PUNTO SUMA RESTA PARENTESISIZQUIERDO PARENTESISDERECHO COMA
%token <cadena> ID
%token <num> NUMERO

%%

programa: inicio sentencias fin
;

sentencias: sentencia sentencias | sentencia
;

sentencia: ENTERO ID PUNTO | ENTERO ID ASIGNACION NUMERO PUNTO | ID ASIGNACION expresion PUNTO | ID ASIGNACION calcularFecha PARENTESISIZQUIERDO NUMERO COMA NUMERO COMA NUMERO PARENTESISDERECHO PUNTO | ID ASIGNACION calcularEdad PARENTESISIZQUIERDO NUMERO COMA NUMERO PARENTESISDERECHO PUNTO | mostrarFecha PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO
;



expresion: primaria 
| expresion operadorAditivo primaria 
; 

operadorAditivo: SUMA 
| RESTA
;

primaria: ID
|CONSTANTE {}
|PARENTESISIZQUIERDO expresion PARENTESISDERECHO
;

expresion : 
    primaria {$$ = $1; }
    | expresion SUMA expresion { $$ = $1 + $3; }
    | expresion RESTA expresion { $$ = $1 - $3; }

sentencia : 
    | ENTERO ID PUNTO {asignarValorA($2, 0);}
    | ENTERO ID ASIGNACION NUMERO PUNTO { asignarValorA($2, $4); }
    | ID ASIGNACION expresion PUNTO { cambiarValorA($1, $3); }
    | ID ASIGNACION calcularFecha PARENTESISIZQUIERDO ID COMA ID COMA ID PARENTESISDERECHO PUNTO  { asignarValorA($1,calcularFecha($5, $7, $9)); }
    | ID ASIGNACION calcularEdad PARENTESISIZQUIERDO NUMERO COMA NUMERO PARENTESISDERECHO PUNTO  { asignarValorA($1,calcularEdad($5, $7)); }
    | mostrarFecha PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO { mostrarFecha(buscar(lista, $3)->info.valor) }
%%

int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}

int main()
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

void mostrarFecha ( int edad){
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