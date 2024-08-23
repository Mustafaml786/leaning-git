%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE *yyin;
void yyerror(const char *s);
int yylex(void);

%}

%union {
    int num;            /* for NUMBER tokens */
    char *str;          /* for IDENTIFIER tokens, STRING, and expressions */
}

%token <num> NUMBER
%token <str> IDENTIFIER
%token <str> STRING
%token BEGIN_TOKEN END VAR INTEGER BOOLEAN IF THEN ELSE WHILE DO WRITELN TRUE FALSE
%token ASSIGN EQ PLUS MINUS TIMES DIVIDE LPAREN RPAREN SEMICOLON DOT COMMA
%token LT GT LE GE

%type <str> expression
%type <str> statement
%type <str> expression_list
%type <str> program statement_list

%left PLUS MINUS
%left TIMES DIVIDE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%nonassoc LT GT LE GE

%%

program:
    BEGIN_TOKEN statement_list END DOT
    ;

statement_list:
    statement
    | statement_list SEMICOLON statement
    | statement_list SEMICOLON
    ;

statement:
    IDENTIFIER ASSIGN expression
    {
        printf("%s = %s;\n", $1, $3);
        free($1);
        free($3);
    }
    | VAR IDENTIFIER
    {
        printf("%s = None;\n", $2);
        free($2);
    }
    | IF expression THEN statement %prec LOWER_THAN_ELSE
    {
        printf("if (%s):\n    %s\n", $2, $4);
        free($2);
        free($4);
    }
    | IF expression THEN statement ELSE statement
    {
        printf("if (%s):\n    %s\nelse:\n    %s\n", $2, $4, $6);
        free($2);
        free($4);
        free($6);
    }
    | WRITELN LPAREN expression_list RPAREN
    {
        printf("print(%s);\n", $3);
        free($3);
    }
    ;

expression_list:
    expression
    {
        $$ = strdup($1);  /* Single expression */
    }
    | expression_list COMMA expression
    {
        char *buffer = (char *) malloc(strlen($1) + strlen($3) + 3);  /* For comma and space */
        sprintf(buffer, "%s, %s", $1, $3);  /* Concatenate expressions */
        $$ = buffer;
        free($1);
        free($3);
    }
    ;

expression:
    NUMBER
    {
        char buffer[20];
        sprintf(buffer, "%d", $1);
        $$ = strdup(buffer);
    }
    | IDENTIFIER
    {
        $$ = strdup($1);
        free($1);
    }
    | STRING    
    {
        $$ = strdup($1);
        free($1);
    }
    | expression PLUS expression
    {
        char *buffer = (char *) malloc(strlen($1) + strlen($3) + 4);
        sprintf(buffer, "(%s + %s)", $1, $3);
        $$ = buffer;
        free($1);
        free($3);
    }
    | expression MINUS expression
    {
        char *buffer = (char *) malloc(strlen($1) + strlen($3) + 4);
        sprintf(buffer, "(%s - %s)", $1, $3);
        $$ = buffer;
        free($1);
        free($3);
    }
    | expression TIMES expression
    {
        char *buffer = (char *) malloc(strlen($1) + strlen($3) + 4);
        sprintf(buffer, "(%s * %s)", $1, $3);
        $$ = buffer;
        free($1);
        free($3);
    }
    | expression DIVIDE expression
    {
        char *buffer = (char *) malloc(strlen($1) + strlen($3) + 4);
        sprintf(buffer, "(%s / %s)", $1, $3);
        $$ = buffer;
        free($1);
        free($3);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    printf("Contents of the input file:\n\n");

    FILE *inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        printf("file not found\n");
        return 1;
    }

    char ch;
    while ((ch = fgetc(inputFile)) != EOF) {
        putchar(ch);
    }

    rewind(inputFile);
    yyin = inputFile;

    printf("\n\nParsing the input file:\n\n");
    yyparse();

    fclose(inputFile);
    return 0;
}
