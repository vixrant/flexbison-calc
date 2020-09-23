%{
#include <stdio.h>
#include "parser.tab.h"

#define YY_DECL int yylex()
%}

%%

[ \t] { /* Eat whitespace */ }
[0-9]+\.[0-9]* { yylval.fval = atof(yytext); return T_FLOAT; }
[0-9]+ { yylval.ival = atoi(yytext); return T_INT; }
\n { return T_NEWLINE; }
"+" { return T_PLUS; }
"-" { return T_MINUS; }
"*" { return T_STAR; }
"/" { return T_SLASH; }
"(" { return T_LEFT; }
")" { return T_RIGHT; }
"exit" { return T_QUIT; }

%%
