%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex(void);
extern void yyerror(char *s);
char *binarioStr(float num);
%}
%union {
    float numBin;
}
%token <numBin> BINARIO
%token MAS MENOS PROD DIV OPEN CLOSE ENTER
%type <numBin> expr
%left MAS MENOS
%left PROD DIV
%start input
%%
input:
      /* vacío */
    | input expr ENTER {
        char *b = binarioStr($2);
        printf("Resultado: %s\n\n", b);
        free(b);
    }
    | input error ENTER { yyerror("Syntax error"); }
    ;

expr:
      BINARIO {
        $$ = $1;
        char *b = binarioStr($$);
        printf("Numero: %s\n", b);
        free(b);
    }
    | MENOS expr          { $$ = -$2; }
    | OPEN expr CLOSE     { $$ = $2; }
    | expr PROD expr      { $$ = $1 * $3; }
    | expr DIV expr       {
          if ($3 == 0.0f) {
              yyerror("Division entre cero");
              YYERROR;
          } else {
              $$ = $1 / $3;
          }
      }
    | expr MAS expr       { $$ = $1 + $3; }
    | expr MENOS expr     { $$ = $1 - $3; }
    ;

%%

char *binarioStr(float num){
    char *result = (char *)malloc(256);
    int conteo = 0;
    if (!result) return NULL;
    memset(result, 0, 256);
    if (num < 0) {
        result[conteo++] = '-';
        num = -num;
    }
    int parte_entera = (int)num;
    float parte_decimal = num - parte_entera;
    if (parte_entera == 0) {
        result[conteo++] = '0';
    } else {
        char temp[128];
        int i = 0;
        while (parte_entera > 0) {
            temp[i++] = (parte_entera % 2) ? '1' : '0';
            parte_entera /= 2;
        }
        for (int j = i - 1; j >= 0; j--) {
            result[conteo++] = temp[j];
        }
    }
    if (parte_decimal > 0) {
        result[conteo++] = '.';
        int limite = 0;
        while (parte_decimal > 0 && limite < 16) {
            parte_decimal *= 2;
            if (parte_decimal >= 1) {
                result[conteo++] = '1';
                parte_decimal -= 1;
            } else {
                result[conteo++] = '0';
            }
            limite++;
        }
    }
    result[conteo] = '\0';
    return result;
}
int main() {
    printf("Ingrese una expresion binaria: ");
    yyparse();
    return 0;
}
void yyerror(char *s) {
    printf("\nError: %s\n", s);
}

