	echo "<Inicio de bison y flex>"
    flex -l lexicoFlex.l
	bison -dv sintacticoBison.y
	gcc -o main sintacticoBison.tab.c lex.yy.c -lfl
	echo "<fin de bison y flex>"