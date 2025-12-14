%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex(void);
extern void yyerror(char *s);
char *romanoStr(int num);
%}
%union {
    int numRomano;
}
%token <numRomano> ROMANO
%token MAS MENOS PROD DIV OPEN CLOSE ENTER
%type <numRomano> expr
%left MAS MENOS
%left PROD DIV
%start input
%%
input:
      /* vacío */
    | input expr ENTER {
        char *b = romanoStr($2);
        printf("Resultado: %s\n\n", b);
        free(b);
    }
    | input error ENTER { yyerror("Syntax error"); }
    ;

expr:
    ROMANO {
        $$ = $1;
        char *b = romanoStr($$);
        printf("Numero: %s\n", b);
        free(b);
    }
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
char *romanoStr(int num){
    char *result = (char *)malloc(10);
    int conteo = 0;
    if (!result) return NULL;
    memset(result, 0, 10);  
    int parte_extraida=num%10;
    
    char *simple="";
    switch(parte_extraida){
    	case 1:
    		simple="I";
    		break;
    	case 2:
    		simple="II";
    		break;
    	case 3:
    		simple="III";
    		break;
    	case 4:
    		simple="IV";
    		break;
    	case 5:
    		simple="V";
    		break;
    	case 6:
    		simple="VI";
    		break;
    	case 7:
    		simple="VII";
    		break;
    	case 8:
    		simple="VIII";
    		break;
    	case 9:
    		simple="IX";
    		break;
    }
    
    num=num-parte_extraida;
    parte_extraida=num%100;  
    char *decenas="";  
    switch(parte_extraida){
    	case 10:
    		decenas="X";
    		break;
    	case 20:
    		decenas="XX";
    		break;
    	case 30:
    		decenas="XXX";
    		break;
    	case 40:
    		decenas="XL";
    		break;
    	case 50:
    		decenas="L";
    		break;
    	case 60:
    		decenas="LX";
    		break;
    	case 70:
    		decenas="LXX";
    		break;
    	case 80:
    		decenas="LXXX";
    		break;
    	case 90:
    		decenas="XC";
    		break;
    }
    
    num=num-parte_extraida;
    parte_extraida=num%1000; 
    char *centenas="";  
    switch(parte_extraida){
    	case 100:
    		centenas="C";
    		break;
    	case 200:
    		centenas="CC";
    		break;
    	case 300:
    		centenas="CCC";
    		break;
    	case 400:
    		centenas="CD";
    		break;
    	case 500:
    		centenas="D";
    		break;
    	case 600:
    		centenas="DC";
    		break;
    	case 700:
    		centenas="DCC";
    		break;
    	case 800:
    		centenas="DCCC";
    		break;
    	case 900:
    		centenas="CM";
    		break;
    }
    
    num=num-parte_extraida; 
    parte_extraida=num%10000;  
    char *miles="";  
    switch(parte_extraida){
    	case 1000:
    		miles="M";
    		break;
    	case 2000:
    		miles="MM";
    		break;
    	case 3000:
    		miles="MMM";
    		break;
    }
    strcat(result,miles);
    strcat(result,centenas);
    strcat(result,decenas);
    strcat(result,simple);
    return result;
}
int main() {
    printf("Ingrese una expresion en numeros romanos: ");
    yyparse();
    return 0;
}

void yyerror(char *s) {
    printf("\nError: %s\n", s);
}

