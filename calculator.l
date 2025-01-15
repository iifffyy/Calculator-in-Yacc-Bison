%{
#include "calculator.tab.h"
%}

%%
[0-9]+(\.[0-9]+)? {
    yylval.dval = atof(yytext);
    return NUMBER;
}
"sin" { return SIN; }
"cos" { return COS; }
"tan" { return TAN; }
"log" { return LOG; }        /* Natural log (log base e) */
"log10" { return LOG10; }    /* Logarithm base 10 */
"sqrt" { return SQRT; }
"factorial" { return FACTORIAL; }
"power" { return POWER; }
"exit" { exit(0); }
"quit" { exit(0); }
[+\-*/^()] { return yytext[0]; }
[ \t] { /* Ignore whitespace */ }
\n { return '\n'; }
. { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}
