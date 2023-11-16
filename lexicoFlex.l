%{

#include <stdio.h>
#include <string.h>
#include "sintacticoBison.tab.h"
void errorLexico();

%}

%option yylineno

DIGITO [0-9]
LETRA ([a-z])
GUION "_"
IDENTIFICADOR {LETRA}.(LETRA|GUION)*
NUMERO {DIGITO}({DIGITO})*
BLANCO [ "\t"]
NUEVALINEA "\n"

%%

"calcularFecha"  { yylval.reservada = strdup(yytext); return CALCULARFECHA; }
"calcularEdad"   { yylval.reservada = strdup(yytext); return CALCULAREDAD; }
"mostrarEdad"    { yylval.reservada = strdup(yytext); return MOSTRAREDAD; }

"int"         { printf("Token tipo: ENTERO %s \n ", yytext); return ENTERO; }
"inicio"         { return INICIO; }
"fin"            { return FIN; }
"es"             { printf("Token tipo: ASIGNACION %s \n ", yytext); yylval.reservada = strdup(yytext); return ASIGNACION; }
" "				 ;
{IDENTIFICADOR}* { printf("Token tipo: IDENTIFICADOR %s \n ", yytext); yylval.reservada = strdup(yytext); return ID; }
{NUMERO}         { yylval.number = atoi(yytext); return NUMERO; }

"."              { return PUNTO; }
","              { return COMA; }
"("              { return PARENTESISIZQUIERDO; }
")"              { return PARENTESISDERECHO; }
"+"              { return SUMA; }
"-"              { return RESTA; }

{BLANCO}+        ; // para reconocer los espacios en blanco
{NUEVALINEA}+    ; // para reconocer los saltos de línea

.                { errorLexico(yytext); return OTHER; }

%%

void errorLexico(char* lexema) {
    printf("Error léxico en la línea %d: Caracter no reconocido: %s\n", yylineno, lexema);
    exit(EXIT_FAILURE);
}

int yywrap(){
    return 1;
}


/*
%option yylineno

DIGITO ([0-9])
LETRA ([a-z])
GUION ("_")
/* {LETRA})({LETRA|GUION} 
IDENTIFICADOR {LETRA}(LETRA|GUION)*
NUMERO {DIGITO}({DIGITO})*

%%

"calcularFecha" 	{yylval.reservada = yytext; return CALCULARFECHA;}
"calcularEdad" 		{yylval.reservada = yytext; return CALCULAREDAD;}
"mostrarEdad" 		{yylval.reservada = yytext; return MOSTRAREDAD;}

"int" 				 return ENTERO;

"inicio" 			 return INICIO;
"fin" 				 return FIN;

"es" 				{yylval.reservada = yytext; return ASIGNACION;}

{IDENTIFICADOR}     {yylval.reservada = yytext; return ID;}
{NUMERO}      		{yylval.number = atoi(yytext); return NUMERO;}

"." 				{return PUNTO;}
"," 				{return COMA;}
"(" 				{return PARENTESISIZQUIERDO;}
")" 				{return PARENTESISDERECHO;}
"+" 				{return SUMA;}
"-" 				{return RESTA;}
[ \t\n]+			; // para reconocer los saltos de linea

.   {errorLexico(); return(OTHER);}

%%
 

void errorLexico(char* other){
	printf("	<<ErrorLexico: caracter %s, en la linea %d>>", yytext, yylineno);
	exit(0); 
}



int yywrap(){
    return 1;
}
/*
int main(int num_args, char** args) {
  if(num_args != 2) {
	cout << "Para analizar un archivo, ejecute: ./Micro <nombre del archivo>";
	cout << endl;
	cout << "Entrada estandar. (Para terminar presione CTRL + C)" << endl;
	yyparse();
  }
  else{
  		FILE* archivo = fopen(args[1],"r");
  		if(archivo == NULL) {
			cout << "Error al abrir el archivo " << args[1] << endl;
			cout << "Entrada estandar. (Para terminar presione CTRL + C)" << endl;
			yyparse();
	  	}
  		else{
	  		yyin = archivo;
	  		yyparse();
	  		fclose(archivo);
	  	    }
  	}
}
*/