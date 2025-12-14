%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex(void);  
extern void yyerror(char *s);  
%}
%union {
    float fnum;
}
%token <fnum> FLOAT
%token MAS MENOS PROD DIV OPEN CLOSE ENTER
%type <fnum> expr
%left MAS MENOS
%left PROD DIV
%start input
%%
input:
    | input expr ENTER { printf("Resultado: %f\n\n", $2); }
    | input error ENTER { yyerror("Syntax error"); }
    ;
expr:
      FLOAT { $$ = $1; printf("Numero: %f\n", $$); }
    | MENOS expr { $$ = -$2; } 
    | OPEN expr CLOSE { $$ = $2; }
    | expr PROD expr { $$ = $1 * $3; }
    | expr DIV expr { 
         if ($3 == 0) {
             yyerror("Division entre cero");
             YYERROR;
         } else {
             $$ = $1 / $3; 
         }
      }
    | expr MAS expr { $$ = $1 + $3; }
    | expr MENOS expr { $$ = $1 - $3; }
    ;
%%
int main() {
    printf("Ingrese una expresion: ");
    yyparse();
    return 0;
}
void yyerror(char *s) {
    printf("\nError: %s\n", s);
}
