all: calc

parser.tab.c parser.tab.h:	parser.y
	bison -t -v -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

calc: lex.yy.c parser.tab.c parser.tab.h
	cc -o calc parser.tab.c lex.yy.c -ll

clean:
	rm calc parser.tab.c lex.yy.c parser.tab.h calc.output
