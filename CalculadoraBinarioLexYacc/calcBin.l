%{
#include <stdio.h>
#include <stdlib.h>
#include "calcBin.tab.h"
float bin_to_float(const char *s) {
    float resultado = 0.0f;
    int punto_decimal = 0;
    float factor = 0.5f;
    for (const char *p = s; *p; p++) {
        if (*p == '.') {
            punto_decimal = 1;
            continue;
        }
        if (*p != '0' && *p != '1') continue;
        if (!punto_decimal) {
            resultado = resultado * 2 + (*p - '0');
        } else {
            resultado += (*p - '0') * factor;
            factor /= 2.0f;
        }
    }
    return resultado;
}
%}

%%
[01]+\.[01]*    {
    yylval.numBin = bin_to_float(yytext);
    return BINARIO;
}
\.[01]+         {
    yylval.numBin = bin_to_float(yytext);
    return BINARIO;
}
[01]+           {
    yylval.numBin = bin_to_float(yytext);
    return BINARIO;
}
[ \t\r]+        ;
[+]             { return MAS; }
[-]             { return MENOS; }
[*]             { return PROD; }
[/]             { return DIV; }
[(]             { return OPEN; }
[)]             { return CLOSE; }
[\n]            { return ENTER; }
.               ;   // Ignorar cualquier otro carácter
%%
int yywrap() {
    return 1;
}

