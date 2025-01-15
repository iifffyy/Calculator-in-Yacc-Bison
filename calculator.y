%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int yylex();
void yyerror(const char *s);
int factorial(int n);
%}

%union {
    double dval;
}

%token <dval> NUMBER
%token SIN COS TAN LOG LOG10 SQRT FACTORIAL POWER
%type <dval> expr
%left '+' '-'
%left '*' '/'
%right UMINUS  /* Unary minus operator precedence */

%%
calculate:
    calculate '\n'
    | calculate expr '\n' { printf("Result: %f\n", $2); }
    | /* empty rule */
;
expr:
    expr '+' expr { $$ = $1 + $3; }
    | expr '-' expr { $$ = $1 - $3; }
    | expr '*' expr { $$ = $1 * $3; }
    | expr '/' expr {
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')' { $$ = $2; }
    | SIN '(' expr ')' { $$ = sin($3 * M_PI / 180); } /* Convert degrees to radians */
    | COS '(' expr ')' { $$ = cos($3 * M_PI / 180); }
    | TAN '(' expr ')' { $$ = tan($3 * M_PI / 180); }
    | LOG '(' expr ')' {
        if ($3 <= 0) {
            yyerror("Cannot compute natural logarithm of non-positive number.");
            $$ = 0;
        } else {
            $$ = log($3);  /* Natural logarithm (base e) */
        }
    }
    | LOG10 '(' expr ')' {
        if ($3 <= 0) {
            yyerror("Cannot compute logarithm base 10 of non-positive number");
            $$ = 0;
        } else {
            $$ = log10($3);  /* Logarithm base 10 */
        }
    }
    | SQRT '(' expr ')' {
        if ($3 < 0) {
            yyerror("Cannot compute square root of negative number");
            $$ = 0;
        } else {
            $$ = sqrt($3);
        }
    }
    | FACTORIAL '(' expr ')' { $$ = factorial((int)$3); }
    | POWER '(' expr '^' expr ')' { $$ = pow($3, $5); }
    | NUMBER { $$ = $1; }
;
%%

int factorial(int n) {
    if (n < 0) {
        return 0;
    }
    int result = 1;
    for (int i = 1; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main() {
    printf("Enter expressions to calculate (type 'exit' or 'quit' to exit): \n");
    while (1) {
        printf("> ");
        yyparse();
    }
    return 0;
}
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
