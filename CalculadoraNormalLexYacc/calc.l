%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
%}
%%
[0-9]+\.[0-9]*([eE][-+]?[0-9]+)?    {    
					yylval.fnum = atof(yytext);
					return FLOAT;
				    }				    
\.[0-9]+([eE][-+]?[0-9]+)?   {    
					yylval.fnum = atof(yytext);
					return FLOAT;
				    }
[0-9]+[eE][-+]?[0-9]+   {    
					yylval.fnum = atof(yytext);
					return FLOAT;
				    }
[0-9]+    { 
               yylval.fnum = atof(yytext);
               return FLOAT;
             }
[ \t\r]+       ;
[+]       { return MAS; }  
[-]       { return MENOS; }  
[*]       { return PROD; }  
[/]       { return DIV; }  
[(]       { return OPEN; } 
[)]       { return CLOSE; }  
[\n]      { return ENTER; }  
.               ;   // Ignorar cualquier otro carácter
%%S
int yywrap() {
    return 1;
}
