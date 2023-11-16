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
NUMERO {DIGITO}({DIGITO})*

%%

"calcularFecha" {return CALCULARFECHA;}
"calcularEdad" {return CALCULAREDAD;}
"mostrarEdad" {return MOSTRAREDAD;}

"int" {return ENTERO;}

"inicio" {return INICIO;}
"fin" {return FIN;}

{IDENTIFICADOR}    {sscanf(yytext, "%s", yylval.name); return ID;}
{ENTERO}      {yylval.number = atoi(yytext); return NUM;}

"es" {return ASIGNACION;}
"." {return PUNTO;}
"," {return COMA;}
"(" {return PARENTESISIZQUIERDO;}
")" {return PARENTESISDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}

.   {errorLexico();}
.   {showError(); return(OTHER);}

%%


vvoid errorLexico(void){
	cout << "Error léxico: caracter \"" << yytext << "\" inválido. En linea " << yylineno << "." << endl;
	exit(0);
}

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