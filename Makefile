scanner: lexical syntax
	@gcc main.c syntax.tab.c -lfl -ly -o parser
lexical:
	@flex lexical.l
syntax:
	@bison -d syntax.y
clean:
	-rm -f lex.yy.c syntax.tab.* parser *.o
