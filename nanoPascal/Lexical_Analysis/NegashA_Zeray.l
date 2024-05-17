
%{
    #include <stdio.h>
    #include <string.h>

    /*identifier*/
    #define IDENTIFIER 1 

    /* comments */
    #define SINGLE_LINE_COMMENT 2  

    /*keywords*/
    #define PROGRAM 3
    #define FUNCTION 4
    #define VAR 5
    #define INTEGER 6
    #define STRING 7
    #define WHILE 8
    #define DO 9
    #define IF 10
    #define THEN 11
    #define ELSE 12
    #define EGIN 13
    #define END 14

    /*integer constant*/
    #define INTEGER_CONSTANT 15

    /*string literal*/
    #define STRING_LITERAL 16

    /*punctuators*/
    #define ASTERISK 17
    #define SLASH 18
    #define PLUS 19
    #define MINUS 20
    #define LESS_THAN 21
    #define GREATER_THAN 22
    #define LESS_THAN_EQUAL 23
    #define GREATER_THAN_EQUAL 24
    #define EQUAL 25
    #define NOT_EQUAL 26
    #define ASSIGNMENT 27
    #define LEFT_PARENTHESIS 28
    #define RIGHT_PARENTHESIS 29
    #define COMMA 30
    #define SEMICOLON 31
    #define PERIOD 32
    #define COLON 33
    #define SINGLE_QUOTE 34

    /*others*/
    #define WHITESPACE 35
    #define NEWLINE 36

%}

/* ----- Regular Expression----- */

/* keywords */
KEYWORD                     "PROGRAM"|"FUNCTION"|"VAR"|"INTEGER"|"STRING"|"WHILE"|"DO"|"IF"|"THEN"|"ELSE"|"BEGIN"|"END"

/* identifiers */
IDENTIFIER_NONDIGIT         [a-z]
IDENTIFIER                  {IDENTIFIER_NONDIGIT}*

/* constants */
DIGIT                           [0-9]
SIGN                            [+-]
NONZERO_DIGIT                   [1-9]
NONZERO_INTEGER_CONSTANT        {SIGN}?{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*

INTEGER_CONSTANT                {NONZERO_INTEGER_CONSTANT}

/* string literal */
S_CHAR                         [a-zA-Z0-9 ]*|[^\'\n\0]
S_CHAR_SEQUENCE                {S_CHAR}+
STRING_LITERAL                 \'{S_CHAR_SEQUENCE}?\'
/* punctuators */
PUNCTUATORS                     "*"|"/"|"+"|"-"|"<"|">"|"<="|">="|"="|"<>"|":="|"("|")"|","|";"|"."|":"

/* comments */
SINGLE_LINE_COMMENT            \{(.*?)\}

%%

{SINGLE_LINE_COMMENT}      {return SINGLE_LINE_COMMENT;}

{KEYWORD}                    {
    if(strcmp(yytext, "PROGRAM") == 0)      {return PROGRAM;} 
    if(strcmp(yytext, "FUNCTION") == 0)     {return FUNCTION;} 
    if(strcmp(yytext, "VAR") == 0)          {return VAR;} 
    if(strcmp(yytext, "INTEGER") == 0)      {return INTEGER;} 
    if(strcmp(yytext, "STRING") == 0)       {return STRING;} 
    if(strcmp(yytext, "WHILE") == 0)        {return WHILE;} 
    if(strcmp(yytext, "DO") == 0)           {return DO;} 
    if(strcmp(yytext, "IF") == 0)           {return IF;} 
    if(strcmp(yytext, "THEN") == 0)         {return THEN;} 
    if(strcmp(yytext, "ELSE") == 0)         {return ELSE;} 
    if(strcmp(yytext, "BEGIN") == 0)        {return EGIN;} 
    if(strcmp(yytext, "END") == 0)          {return END;}
}


{IDENTIFIER}                    {return IDENTIFIER;}
{INTEGER_CONSTANT}              {return INTEGER_CONSTANT;}
{STRING_LITERAL}                {return STRING_LITERAL;}

{PUNCTUATORS}                   {
    if(strcmp(yytext, "*") == 0)             {return ASTERISK;}
    if(strcmp(yytext, "/") == 0)             {return SLASH;}
    if(strcmp(yytext, "+") == 0)             {return PLUS;}
    if(strcmp(yytext, "-") == 0)             {return MINUS;}
    if(strcmp(yytext, "<") == 0)             {return LESS_THAN;}
    if(strcmp(yytext, ">") == 0)             {return GREATER_THAN;}
    if(strcmp(yytext, "<=") == 0)            {return LESS_THAN_EQUAL;}
    if(strcmp(yytext, ">=") == 0)            {return GREATER_THAN_EQUAL;}
    if(strcmp(yytext, "=") == 0)             {return EQUAL;}
    if(strcmp(yytext, "<>") == 0)            {return NOT_EQUAL;}
    if(strcmp(yytext, ":=") == 0)            {return ASSIGNMENT;}
    if(strcmp(yytext, "(") == 0)             {return LEFT_PARENTHESIS;}
    if(strcmp(yytext, ")") == 0)             {return RIGHT_PARENTHESIS;}
    if(strcmp(yytext, ",") == 0)             {return COMMA;}
    if(strcmp(yytext, ";") == 0)             {return SEMICOLON;}
    if(strcmp(yytext, ".") == 0)             {return PERIOD;}
    if(strcmp(yytext, ":") == 0)             {return COLON;}
}

"\n"|"\t"|" "             {/* ignore whitespace */}
.                       { /*printf("Error: Unrecognized character %s\n", yytext);*/  }
%%