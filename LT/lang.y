%{
#include<stdio.h>
#include<string.h>
int yylex(void);
void yyerror(char *);
extern FILE *yyin;
char* sys[26][100];
%}

%token ID VARIABLE CHAR INT START END VAR CONCAT COPY SEARCH SHOW VALUEAT REPLACE
%union{
int var;
char* strval;
char charval;
int intval;
}
%type <strval>ID
%type <var>VARIABLE
%type <charval>CHAR
%type <intval>INT

%%
program: start

start: START '\n' function END

function:operation
	     |function operation
		 ;
		 
operation:assignment 
		  |concat
		  |search
		  |display
		  |variable
		  |valueat
		  |replace
		  |copy
		  ;

variable: VAR VARIABLE ';' '\n'
			|VAR VARIABLE ',' variable1 ';' '\n'
			;
			
variable1: VARIABLE ',' variable1
			|VARIABLE
			;

assignment: VARIABLE '=' ID ';' '\n'  {
									for(int i=0;i<strlen($3);i++)
									{ 
										sys[$1][i]=$3[i];
									}
								   }
			
concat: VARIABLE '=' CONCAT '(' VARIABLE ',' VARIABLE ')' ';' '\n'	{	int i=0,k=0;
																		while(sys[$5][i]!='\0')
																		{
																			sys[$1][i]=sys[$5][i];
																			i++;
																			k++;
																		}
																		i=0;
																		sys[$1][k++]=' ';
																		while(sys[$7][i]!='\0')
																		{
																			sys[$1][k]=sys[$7][i];
																			i++;
																			k++;
																		}
																	}												
		;
		
search: SEARCH '(' VARIABLE ',' CHAR ')' ';' '\n'	{ int i=0,flag=0;char c=$5;
													while(sys[$3][i]!='\0')
													{
														if(sys[$3][i]==c || sys[$3][i]+32==c)
														{	
															flag=1;
															break;
														}
														i++;
													}
													if(flag==0)
													{
														printf("%c is not available in given variable\n",c);
													}
													else
													{
														printf("%c is available in given variable\n",c);
													}
												}
display: SHOW '(' VARIABLE ')' ';' '\n'	{
										int i=0;
										while(sys[$3][i]!='\0')
										{
											printf("%c",sys[$3][i]);
											i++;
										}
										printf("\n");
									}

valueat: VALUEAT '(' VARIABLE ',' INT ')' ';' '\n' {printf("Value at %d position is %c\n",$5,sys[$3][$5-1]);}

replace: REPLACE '(' VARIABLE ',' CHAR ',' CHAR ')' ';' '\n' {	int i=0;char c1=$5,c2=$7;

																	while(sys[$3][i]!='\0')
																	{
																		if(sys[$3][i]==c1)
																		{
																			sys[$3][i]=c2;
																		}
																		if(sys[$3][i]+32==c1)
																		{
																			sys[$3][i]=c2-32;
																		}
																		i++;
																	}
																}

copy: COPY '(' VARIABLE ',' VARIABLE ')' ';' '\n' {
														int i=0;
														while(sys[$3][i]!='\0')
														{
															sys[$5][i]=sys[$3][i];
															i++;
														}
														while(sys[$5][i]!='\0')
														{
															sys[$5][i]='\0';
															i++;
														}
													}

%%

void yyerror(char *s){
	fprintf(stderr,"%s\n",s);
}

int main(int argc,char **argv){
if(argc >1)
{
	yyin=fopen(argv[1],"r");
}
else{
	printf("Enter file name");
	return 1;
}
yyparse();
return 0;
}