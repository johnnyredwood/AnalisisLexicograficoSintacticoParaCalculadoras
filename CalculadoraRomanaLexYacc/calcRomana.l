%{
#include <stdio.h>
#include <stdlib.h>
#include "calcRomana.tab.h"
#include <string.h>
float roman_to_int(const char *s) {
    int result = 0;
    int longitud = strlen(s);
    for (int i = 0; i< longitud; i++) {      
        switch(s[i]){
        	case 'M':
        		result+=1000;
        		break;
        	case 'D':
        		result+=500;
        		break;
        	case 'C':
        		if(i<longitud-1 && (s[i+1]=='M' || s[i+1]=='D')){
        			result-=100;
        		} else{
        			result+=100;
        		}
        		break;
        	case 'L':
        		result+=50;
        		break;
        	case 'X':
        		if(i<longitud-1 && (s[i+1]=='L' || s[i+1]=='C')){
        			result-=10;
        		} else{
        			result+=10;
        		}
        		break;
        	case 'V':
			result+=5;
			break;
        	case 'I':
        		if(i<longitud-1 && (s[i+1]=='V' || s[i+1]=='X')){
        			result-=1;
        		} else{
        			result+=1;
        		}
        		break;
        }
    }
    return result;
}
%}
%%
[IVXLCDM]+   {
    yylval.numRomano = roman_to_int(yytext);
    return ROMANO;
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

