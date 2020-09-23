%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
        int ival;
        float fval;
}

%token <ival> T_INT
%token <fval> T_FLOAT
%token T_PLUS T_MINUS T_STAR T_SLASH T_LEFT T_RIGHT
%token T_NEWLINE T_QUIT

%left T_PLUS T_MINUS
%left T_STAR T_SLASH

%type   <ival>          expr
%type   <fval>          mexpr

%start calculation

%%

calculation:    /* nothing */
        |       calculation line
        ;

line:           T_NEWLINE
        |       mexpr T_NEWLINE { printf("\t = %f\n", $1); }
        |       expr T_NEWLINE { printf("\t = %i\n", $1); }
        |       T_QUIT T_NEWLINE { printf("bye\n"); }
        ;

mexpr:           T_FLOAT { $$ = $1; }
        |       mexpr T_PLUS mexpr { $$ = $1 + $3; }
        |       mexpr T_MINUS mexpr { $$ = $1 - $3; }
        |       mexpr T_STAR mexpr { $$ = $1 * $3; }
        |       mexpr T_SLASH mexpr { $$ = $1 / $3; }
        |       T_LEFT mexpr T_RIGHT { $$ = $2; }
        |       mexpr T_PLUS expr { $$ = $1 + $3; }
        |       mexpr T_MINUS expr { $$ = $1 - $3; }
        |       mexpr T_STAR expr { $$ = $1 * $3; }
        |       mexpr T_SLASH expr { $$ = $1 / $3; }
        |       expr T_PLUS mexpr { $$ = $1 + $3; }
        |       expr T_MINUS mexpr { $$ = $1 - $3; }
        |       expr T_STAR mexpr { $$ = $1 * $3; }
        |       expr T_SLASH mexpr { $$ = $1 / $3; }
        ;

expr:            T_INT { $$ = $1; }
        |       expr T_PLUS expr { $$ = $1 + $3; }
        |       expr T_MINUS expr { $$ = $1 - $3; }
        |       expr T_STAR expr { $$ = $1 * $3; }
        |       T_LEFT expr T_RIGHT { $$ = $2; }
        ;

%%

int main() {
    yyin = stdin;

    do {
        yyparse();
    } while(!feof(yyin));

    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Parse error: %s \n", s);
    exit(1);
}
