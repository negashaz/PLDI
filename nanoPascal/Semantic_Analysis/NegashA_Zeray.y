%{
    #include <stdio.h>
    #include <string.h>

    extern int yylex();
    extern int yytext();
    void yyerror(char *s);


%}

%union{
    int intval;
    int instr_number;
    int num_params;

    char* char_value;

    Expression* expr;
    Statement* stat;
    symboltype* sym_type;
    sym* symp;

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

%type <expr>
        factor
        term
        simple_expression
        expression
        
%type <num_params>
        expression_list
        variable_list

%type <sym_type> 
    type

%type <symp>
    function_declaration  
    function_declaration_list
       
       
%type <stat>
        statement
        selection_statement
        iteration_statement
        statement_list
        compound_statement
%%

/* -------------- Expressions -------------- */
factor
    : IDENTIFIER
      { 
        $$ = new Expression();
        $$->loc = ST->lookup($1);
        $$->type = $$->loc->type->type;
      }
    | INTEGER_CONSTANT
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("int"));
        $$->loc->val = $1;
        $$->type = "int";
        emit("=", $$->loc->name, $1);
      }
    | STRING_LITERAL
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("string"));
        $$->loc->val = $1;
        $$->type = "string";
        emit("=", $$->loc->name, $1);
      }
    | LEFT_PARENTHESIS expression RIGHT_PARENTHESIS
      { $$ = $2; }
    | IDENTIFIER LEFT_PARENTHESIS expression_list RIGHT_PARENTHESIS
      { 
        $$ = new Expression();
        //handle function call
        //assume $3->loc is a list of arguments for simplicity
        emit("call", $1, $3->loc->name);
        $$->loc = gentemp(new symboltype("int")); //assume return type is int
        emit("=", $$->loc->name, "RET"); 
        $$->type = "int";
      }
    ;

term
    : factor
      { $$ = $1; }
    | term ASTERISK factor
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("int"));
        emit("*", $$->loc->name, $1->loc->name, $3->loc->name);
        $$->type = "int";
      }
    | term SLASH factor
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("int"));
        emit("/", $$->loc->name, $1->loc->name, $3->loc->name);
        $$->type = "int";
      }
    ;

simple_expression
    : term
      { $$ = $1; }
    | simple_expression PLUS term
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("int"));
        emit("+", $$->loc->name, $1->loc->name, $3->loc->name);
        $$->type = "int";
      }
    | simple_expression MINUS term
      { 
        $$ = new Expression();
        $$->loc = gentemp(new symboltype("int"));
        emit("-", $$->loc->name, $1->loc->name, $3->loc->name);
        $$->type = "int";
      }
    ;

expression
    : simple_expression
      { $$ = $1; }
    | simple_expression LESS_THAN simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if < ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    | simple_expression GREATER_THAN simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if > ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    | simple_expression LESS_THAN_EQUAL simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if <= ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    | simple_expression GREATER_THAN_EQUAL simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if >= ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    | simple_expression EQUAL simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if == ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    | simple_expression NOT_EQUAL simple_expression
      { 
        $$ = new Expression();
        $$->truelist = makelist(nextinstr());
        $$->falselist = makelist(nextinstr() + 1);
        emit("if != ", $1->loc->name, $3->loc->name, "goto ");
        emit("goto ");
      }
    ;

expression_list
    : expression
      { 
        $$ = new Expression();
        $$->loc = new sym();
        $$->loc->name = $1->loc->name;
      }
    | expression_list COMMA expression
      { 
        $$ = new Expression();
        $$->loc = new sym();
        $$->loc->name = $1->loc->name + ", " + $3->loc->name;
      }
    ;


/* -------------- Statements -------------- */
statement
    : IDENTIFIER ASSIGNMENT expression
      { 
        emit("=", $1, $3->loc->name);
      }
    | compound_statement
      { $$ = $1; }
    | selection_statement
      { $$ = $1; }
    | iteration_statement
      { $$ = $1; }
    ;

selection_statement
    : IF expression THEN statement
      { 
        backpatch($2->truelist, nextinstr());
        $$ = new Statement();
        $$->nextlist = merge($2->falselist, $4->nextlist);
      }
    | IF expression THEN statement ELSE statement
      { 
        backpatch($2->truelist, nextinstr());
        $4->nextlist = merge($4->nextlist, makelist(nextinstr()));
        emit("goto ");
        backpatch($2->falselist, nextinstr());
        $$ = new Statement();
        $$->nextlist = merge($4->nextlist, $6->nextlist);
      }
    ;   

iteration_statement
    : WHILE expression DO statement
      { 
        int begin = nextinstr();
        backpatch($2->truelist, begin);
        $4->nextlist = merge($4->nextlist, makelist(nextinstr()));
        emit("goto " + to_string(begin));
        backpatch($2->falselist, nextinstr());
        $$ = new Statement();
        $$->nextlist = $4->nextlist;
      }
    ;

statement_list
    : statement
      { $$ = new Statement(); $$->nextlist = $1->nextlist; }
    | statement_list SEMICOLON statement
      { $$ = new Statement(); $$->nextlist = merge($1->nextlist, $3->nextlist); }
    ;
    
compound_statement
    : EGIN statement_list END
      { $$ = $2; }
    ;

/* -------------- Declarations -------------- */
parameter_list
    : variable_list COLON type
      { 
        for (auto& id : $1) {
          id->type = new symboltype($3);
        }
      }
    | parameter_list SEMICOLON variable_list COLON type
      { 
        for (auto& id : $3) {
          id->type = new symboltype($5);
        }
      }
    ;   

function_header
    : FUNCTION IDENTIFIER LEFT_PARENTHESIS parameter_list RIGHT_PARENTHESIS COLON type SEMICOLON
      { 
        //create a new function symbol and its type
        sym* func = new sym($2, new symboltype($8));
        func->nested = new symtable($2);
        ST->table.push_back(func);
        ST = func->nested;
      }
    ;

function_declaration 
    : function_header declaration_list_opt compound_statement
      { 
        ST = ST->parent; 
      }
    ;

function_declaration_list
    : function_declaration_list_opt function_declaration SEMICOLON
    ;

type
    : INTEGER
      { $$ = "int"; }
    | STRING
      { $$ = "string"; }
    ;

variable_list
    : IDENTIFIER
      { 
        $$ = new vector<sym*>();
        $$->push_back(ST->lookup($1));
      }
    | variable_list COMMA IDENTIFIER
      { 
        $$ = $1;
        $$->push_back(ST->lookup($3));
      }
    ;


declaration_list
    : declaration_list_opt VAR variable_list COLON type SEMICOLON
      { 
        for (auto& id : $3) {
          id->type = new symboltype($5);
        }
      }
    ;

declaration_list_opt
    : declaration_list
    | /* empty */
    ;

function_declaration_list_opt
    : function_declaration_list
    | /* empty */
    ;

/* -------------- Program -------------- */
program
    : PROGRAM IDENTIFIER SEMICOLON declaration_list_opt function_declaration_list_opt compound_statement PERIOD
      { 
        //Perform any final actions for program
        emit("end");
      }
    ;

%%

void yyerror(string s) {       
    cout<<s<<endl;
}