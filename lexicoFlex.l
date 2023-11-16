%{

#include <stdio.h>
#include <string.h>
#include "sintacticoBison.tab.h"
void errorLexico();
%}


%option yylineno

DIGITO ([0-9])
LETRA ([a-z])
GUION (_)
/* {LETRA})({LETRA|GUION} */
IDENTIFICADOR {LETRA}(LETRA|GUION)*
NUMERO {DIGITO}({DIGITO})*

%%

"calcularFecha" 	{yylval.reservada = yytext; return CALCULARFECHA;}
"calcularEdad" 		{yylval.reservada = yytext; return CALCULAREDAD;}
"mostrarEdad" 		{yylval.reservada = yytext; return MOSTRAREDAD;}

"int" 				{yylval.reservada = yytext; return ENTERO;}

"inicio" 			{ return INICIO;}
"fin" 				{ return FIN;}

"es" 				{yylval.reservada = yytext; return ASIGNACION;}

{IDENTIFICADOR}     {yylval.reservada = yytext; return (ID);}
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