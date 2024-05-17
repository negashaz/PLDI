#include <stdio.h>
#include "NegashA_Zeray.tab.h"

extern char * yytext;
extern FILE * yyin;
extern int yyparse();

int main()
{
    FILE *testfile = fopen ("NegashA_Zeray.np", "r");


    if (!testfile){
        printf ("Error opening file. Check if it exists.\n");
        return -1;
    }

    yyin = testfile;
    yyparse();
    return 0;
}