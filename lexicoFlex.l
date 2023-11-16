%{

#include <stdio.h>
#include <string.h>
#include "sintacticoBison.tab.h"
void showError();
%}

DIGITO ([0-9])
LETRA ([a-z])
GUION (_)
/* {LETRA})({LETRA|GUION} */
IDENTIFICADOR (LETRA)(LETRA|GUION)*
NUMERO {DIGITO}({DIGITO})*

%%

"calcularFecha" 	{yyval.reservada = yytext; return CALCULARFECHA;}
"calcularEdad" 		{yyval.reservada = yytext; return CALCULAREDAD;}
"mostrarEdad" 		{yyval.reservada = yytext; return MOSTRAREDAD;}

"int" 				{yyval.reservada = yytext; return ENTERO;}

"inicio" 			{yyval.reservada = yytext; return INICIO;}
"fin" 				{yyval.reservada = yytext; return FIN;}

"es" 				{yyval.reservada = yytext; return ASIGNACION;}

{IDENTIFICADOR}     {sscanf(yytext, "%s", yylval.cad); return (ID);}
{NUMERO}      		{yylval.number = atoi(yytext); return NUMERO;}


"." {return PUNTO;}
"," {return COMA;}
"(" {return PARENTESISIZQUIERDO;}
")" {return PARENTESISDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}

.   {errorLexico(); return(OTHER);}

%%


vvoid errorLexico(char* other){
	printf("	<<ErrorLexico:  \"%s\" >>".other);
	cout << "Error léxico: caracter \"" << yytext << "\" inválido. En linea " << yylineno << "." << endl;
	exit(0);
}

/*

int yywrap(){
    return 1;
}

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