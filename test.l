%{

#include <stdio.h>
#include <string.h>
#include "test.tab.h"
void showError();
%}

DIGITO [0-9]
LETRA [a-z]
GUION "_"

IDENTIFICADOR {LETRA}({LETRA|GUION})*
ENTERO {DIGITO}({DIGITO})*

%%

{IDENTIFICADOR}    {sscanf(yytext, "%s", yylval.name); return ID;}
{ENTERO}      {yylval.number = atoi(yytext); return NUM;}

"es" {return ASIGNACION;}
"." {return PUNTO;}
"," {return COMA;}
"(" {return PARENTESISIZQUIERDO;}
")" {return PARENTESISDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}

"calcularFecha" {return CALCULARFECHA;}
"calcularEdad" {return CALCULAREDAD;}
"mostrarEdad" {return MOSTRAREDAD;}

"int" {return ENTERO;}

"inicio" {return INICIO;}
"fin" {return FIN;}

.      		     {showError(); return(OTHER);}

%%


void showError(){
    printf("Other input");
}
int yywrap(){
    return 1;
}
