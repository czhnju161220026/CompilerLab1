scanner: lexical syntax
	@gcc -std=c99 main.c grammarTree.c syntax.tab.c -lfl -ly -o parser
lexical:
	@flex lexical.l
syntax:
	@bison -d syntax.y
clean:
	-rm -f lex.yy.c syntax.tab.* parser *.o
