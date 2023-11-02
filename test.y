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

sentencia: ENTERO ID PUNTO| ENTERO ID ASIGNACION NUMERO PUNTO | ID ASIGNACION expresion PUNTO | ID ASIGNACION calcularFecha PARENTESISIZQUIERDO listaIdentificadores PARENTESISDERECHO PUNTO | ID ASIGNACION calcularEdad PARENTESISIZQUIERDO listaIdentificadores PARENTESISDERECHO PUNTO | mostrarFecha PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO
;

listaIdentificadores: ID COMA listaIdentificadores | ID

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
