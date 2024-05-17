
%{
     #include <stdio.h>
    #include <string.h>
    #include "NegashA_Zeray.tab.h"
    extern void yyerror(const char *s);
%}

%option noyywrap

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
S_CHAR                         [a-zA-Z0-9 ]*|[^\']
S_CHAR_SEQUENCE                {S_CHAR}+
STRING_LITERAL                 \'{S_CHAR_SEQUENCE}?\'

/* punctuators */
PUNCTUATORS                     "*"|"/"|"+"|"-"|"<"|">"|"<="|">="|"="|"<>"|":="|"\("|"\)"|","|";"|"."|":"

/* comments */
SINGLE_LINE_COMMENT            \{(.*?)\}

%%

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

"\n"|" "|"\t"|{SINGLE_LINE_COMMENT}              { /* ignore white space and comments */ }
.                       { /* ignore invalid characters */ }
%%