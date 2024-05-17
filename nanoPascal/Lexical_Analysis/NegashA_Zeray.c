#include <stdio.h>

/*identifier*/
#define IDENTIFIER 1 

/* comments */
#define SINGLE_LINE_COMMENT_BODY 2  

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

/*others*/
#define WHITESPACE 34
#define NEWLINE 35

extern int yylex();
extern char* yytext;
extern FILE* yyin;

int main(){
    FILE *testFile = fopen("NegashA_Zeray.np", "r");

    if(!testFile){
        printf("File not found\n");
        return -1;
    }

    yyin = testFile;
    int token;

    while (token =yylex()){
        switch (token){

            case SINGLE_LINE_COMMENT_BODY:
                printf("<SINGLE_LINE_COMMENT_BODY: , %d, %s >\n", token, yytext);
                break;

            case IDENTIFIER:
                printf("<IDENTIFIER: , %d, %s >\n", token, yytext);
                break;
            
            case PROGRAM:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case FUNCTION:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case VAR:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case INTEGER:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case STRING:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case WHILE:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case DO:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case IF:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case THEN:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case ELSE:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case EGIN:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;
            case END:
                printf("<KEYWORD: , %d, %s >\n", token, yytext);
                break;

            case INTEGER_CONSTANT:
                printf("<INTEGER_CONSTANT: , %d, %s >\n", token, yytext);
                break;
            case STRING_LITERAL:
                printf("<STRING_LITERAL: , %d, %s >\n", token, yytext);
                break;
            
            case ASTERISK:
                printf("<ASTERISK: , %d, %s >\n", token, yytext);
                break;
            case SLASH:
                printf("<SLASH: , %d, %s >\n", token, yytext);
                break;
            case PLUS:
                printf("<PLUS: , %d, %s >\n", token, yytext);
                break;
            case MINUS:
                printf("<MINUS: , %d, %s >\n", token, yytext);
                break;
            case LESS_THAN:
                printf("<LESS_THAN: , %d, %s >\n", token, yytext);
                break;
            case GREATER_THAN:
                printf("<GREATER_THAN: , %d, %s >\n", token, yytext);
                break;
            case LESS_THAN_EQUAL:
                printf("<LESS_THAN_EQUAL: , %d, %s >\n", token, yytext);
                break;
            case GREATER_THAN_EQUAL:
                printf("<GREATER_THAN_EQUAL: , %d, %s >\n", token, yytext);
                break;
            case EQUAL:
                printf("<EQUAL: , %d, %s >\n", token, yytext);
                break;
            case NOT_EQUAL:
                printf("<NOT_EQUAL: , %d, %s >\n", token, yytext);
                break;
            case ASSIGNMENT:
                printf("<ASSIGNMENT: , %d, %s >\n", token, yytext);
                break;
            case LEFT_PARENTHESIS:
                printf("<LEFT_PARENTHESIS: , %d, %s >\n", token, yytext);
                break;
            case RIGHT_PARENTHESIS:
                printf("<RIGHT_PARENTHESIS: , %d, %s >\n", token, yytext);
                break;
            case COMMA:
                printf("<COMMA: , %d, %s >\n", token, yytext);
                break;
            case SEMICOLON:
                printf("<SEMICOLON: , %d, %s >\n", token, yytext);
                break;
            case PERIOD:
                printf("<PERIOD: , %d, %s >\n", token, yytext);
                break;
            case COLON:
                printf("<COLON: , %d, %s >\n", token, yytext);
                break;
        }
    }
    return 0;

}

int yywrap(){
    return 1;
}
            