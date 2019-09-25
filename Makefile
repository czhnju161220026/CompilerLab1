scanner: lexical
	gcc main.c lex.yy.c -lfl -o scanner
lexical:
	flex lexical.l
clean:
	-rm -f lex.yy.c scanner *.o
