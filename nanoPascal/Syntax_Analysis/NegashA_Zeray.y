%{
    #include <stdio.h>
    #include <string.h>

    extern int yylex();
    extern int yytext();
    void yyerror(char *s);


%}

%union{
    int ival;
    char *sval;

}

%token PROGRAM 
%token FUNCTION 
%token VAR 
%token INTEGER 
%token STRING 
%token WHILE 
%token DO 
%token IF 
%token THEN 
%token ELSE 
%token EGIN 
%token END

%token IDENTIFIER
%token INTEGER_CONSTANT
%token STRING_LITERAL

%token LESS_THAN 
%token GREATER_THAN 
%token LESS_THAN_EQUAL
%token GREATER_THAN_EQUAL
%token EQUAL
%token NOT_EQUAL
%token ASSIGNMENT
%token LEFT_PARENTHESIS 
%token RIGHT_PARENTHESIS 
%token COMMA 
%token SEMICOLON
%token PERIOD
%token COLON 
%token PLUS
%token MINUS
%token ASTERISK
%token SLASH

%left PLUS MINUS
%left ASTERISK SLASH
%nonassoc LESS_THAN GREATER_THAN LESS_THAN_EQUAL GREATER_THAN_EQUAL EQUAL NOT_EQUAL

%start program

%%

/* -------------- Expressions -------------- */
factor
    : IDENTIFIER{printf("Rule 1: factor\n");}
    | INTEGER_CONSTANT{printf("Rule 1: factor\n");}
    | STRING_LITERAL{printf("Rule 1: factor\n");}
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS{printf("Rule 1: factor\n");}
    | IDENTIFIER LEFT_PARENTHESIS expression_list RIGHT_PARENTHESIS{printf("Rule 1: factor\n");}
    ;

term
    : factor{printf("Rule 1: term\n");}
    | term ASTERISK factor{printf("Rule 1: term\n");}
    | term SLASH factor{printf("Rule 1: term\n");}
    ;

simple_expression
    : term{printf("Rule 1: simple_expression\n");}
    | simple_expression PLUS term{printf("Rule 1: simple_expression\n");}
    | simple_expression MINUS term{printf("Rule 1: simple_expression\n");}
    ;

expression
    : simple_expression
    | simple_expression LESS_THAN simple_expression{printf("Rule 1: expression\n");} 
    | simple_expression GREATER_THAN simple_expression{printf("Rule 1: expression\n");}
    | simple_expression LESS_THAN_EQUAL simple_expression{printf("Rule 1: expression\n");}
    | simple_expression GREATER_THAN_EQUAL simple_expression{printf("Rule 1: expression\n");}
    | simple_expression EQUAL simple_expression {printf("Rule 1: expression\n");}
    | simple_expression NOT_EQUAL simple_expression{printf("Rule 1: expression\n");}
    ;

expression_list
    : expression{printf("Rule 1: expression_list\n");}
    | expression_list COMMA expression{printf("Rule 1: expression_list\n");}
    ;


/* -------------- Statements -------------- */
statement
    : IDENTIFIER ASSIGNMENT expression{printf("Rule 2: statement\n");}
    | compound_statement{printf("Rule 2: statement\n");}
    | selection_statement{printf("Rule 2: statement\n");}
    | iteration_statement{printf("Rule 2: statement\n");}
    ;

selection_statement
    : IF expression THEN statement{printf("Rule 2: selection_statement\n");}
    | IF expression THEN statement ELSE statement{printf("Rule 2: selection_statement\n");}
    ;   

iteration_statement
    : WHILE expression DO statement{printf("Rule 2: iteration_statement\n");}
    ;

statement_list
    : statement{printf("Rule 2: statement_list\n");}
    | statement_list SEMICOLON statement{printf("Rule 1: statement_list\n");}
    ;
    
compound_statement
    : EGIN statement_list END{printf("Rule 1: compound_statement\n");}
    ;

/* -------------- Declarations -------------- */
parameter_list
    : variable_list COLON type{printf("Rule 3: parameter_list\n");}
    | parameter_list SEMICOLON variable_list COLON type{printf("Rule 3: parameter_list\n");}
    ;   

function_header
    : FUNCTION IDENTIFIER LEFT_PARENTHESIS parameter_list RIGHT_PARENTHESIS COLON type SEMICOLON{printf("Rule 3: function_header\n");}
    ;

function_declaration 
    : function_header declaration_list_opt compound_statement{printf("Rule 3: function_declaration\n");}
    ;

function_declaration_list
    : function_declaration_list_opt function_declaration SEMICOLON{printf("Rule 3: function_declaration_list\n");}
    ;

type
    : INTEGER{printf("Rule 3: type\n");}
    | STRING{printf("Rule 3: type\n");}
    ;

variable_list
    : IDENTIFIER{printf("Rule 3: variable_list\n");}
    | variable_list COMMA IDENTIFIER{printf("Rule 3: variable_list\n");}
    ;


declaration_list
    : declaration_list_opt VAR variable_list COLON type SEMICOLON{printf("Rule 3: declaration_list\n");}
    ;

/* -------------- Program -------------- */
program
    : PROGRAM IDENTIFIER SEMICOLON declaration_list_opt function_declaration_list_opt compound_statement PERIOD{printf("program\n");}
    ;

declaration_list_opt
    : declaration_list
    | /* empty */
    ;

function_declaration_list_opt
    : function_declaration_list
    | /* empty */
    ;

%%

void yyerror(char *s) {
    printf("Error: %s on '%s'\n", s, yytext);
}