%{
#include "p.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

"begin"      { printf("\t\t\t\t\t\tbegin token \n"); return BEGIN_TOKEN; }
"end"        { printf("\t\t\t\t\t\tend token \n"); return END; }
"var"        { printf("\t\t\t\t\t\tvar token \n");return VAR; }
"integer"    { printf("\t\t\t\t\t\tinteger token \n"); return INTEGER; }
"boolean"    { return BOOLEAN; }
"if"         { return IF; }
"then"       { return THEN; }
"else"       { return ELSE; }
"while"      { return WHILE; }
"do"         { return DO; }
"writeln"    { return WRITELN; }
"true"       { return TRUE; }
"false"      { return FALSE; }

\"[^\"\n]*\" { yylval.str = strdup(yytext); printf("\t\t\t\t\t\tstring token \n"); return STRING;}
[ \t\r\n]    ; /* ignore whitespace */
[0-9]+       { yylval.num = atoi(yytext); printf("\t\t\t\t\t\tnumber token \n");return NUMBER; }
[a-zA-Z_][a-zA-Z_0-9]* { yylval.str = strdup(yytext); printf("\t\t\t\t\t\tidentifier token \n");return IDENTIFIER; }

":="         { printf("\t\t\t\t\t\tassign token \n");return ASSIGN; }
"="          { return EQ; }
"+"          { return PLUS; }
"-"          { return MINUS; }
"*"          { return TIMES; }
">"          { printf("\t\t\t\t\t\t > token \n"); return GT; }
"<"          { printf("\t\t\t\t\t\t < token \n"); return LT; }
"/"          { return DIVIDE; }
"("          { printf("\t\t\t\t\t\t ( token \n"); return LPAREN; }
")"          { printf("\t\t\t\t\t\t ) token \n"); return RPAREN; }
";"          { return SEMICOLON; }
"."          { printf("\t\t\t\t\t\tdot token \n");return DOT; }
","          { printf("\t\t\t\t\t\tcomma token \n"); return COMMA; } /* Added COMMA token */
