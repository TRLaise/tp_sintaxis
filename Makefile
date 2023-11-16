	default:
			clear
			echo "<Inicio de bison y flex>"
    		flex lexicoFlex.l
			bison -dv sintacticoBison.y
			gcc  sintacticoBison.tab.c lex.yy.c -o main
			echo "<fin de bison y flex>"