%{
#include<stdlib.h>
#include "lang.tab.h"
void yyerror(char *);
%}

%%

[0-9]+ {
			yylval.intval=atoi(yytext);
			return INT; 
		}

[A-Z] {
		yylval.var=*yytext - 'A';
		return VARIABLE;
	  }

[A-Z][a-z]+   {
				yylval.strval=strdup(yytext);
				return ID;
			}

[a-z] { yylval.charval=*yytext;
		return CHAR; }

start@ {return START;}
show {return SHOW;}
search {return SEARCH;}
concat {return CONCAT;}
copy {return COPY;}
valueAt {return VALUEAT;}
var {return VAR;}
replace {return REPLACE;}
@end {return END;}
","|"="|"("|")"|";" {return *yytext;} 
[\n] return *yytext;
[\t];
.yyerror ("invalid character");
%%

int yywrap(void){
	return 1;
}