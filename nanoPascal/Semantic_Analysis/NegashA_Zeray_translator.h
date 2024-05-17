#ifndef _NEGASHA_ZERAY_TRANSLATOR_H
#define _NEGASHA_ZERAY_TRANSLATOR_H

#include <bits/stdc++.h>

extern  char* yytext;
extern  int yyparse();

using namespace std;

#define lsit list<symbol>::iterator
#define listi list<int>
#define lstsym list<symbol>
#define vec vector
#define stri string
#define vd void

class symbol;						//stands for an entry in ST
class symboltype;				//stands for the type of a symbol in ST
class symboltable;					//stands for ST
class quad;						//stands for a single entry in the quad Array
class quadArray;

class symbol 
{                     
	public:
        //name
		stri name;	
        //type
		symboltype *type;
        //size			
		int size;
        //offset				
		int offset;		
        //to the nested symbol table			
		symboltable* nested;			

		//creating
		symbol (stri , stri t="int", symboltype* ptr = NULL, int width = 0);
		//to update the symbol table entry 
		symbol* update(symboltype*); 	
};

typedef symbol s;
class symboltype 
{                      
	public:
        //storing 
		str type;					//stores the type of symbol. 
		int width;					    //stores the size of Array (if we encounter an Array) and it is 1 in default case
		symboltype* arrtype;			//for arr1s which are multidimensional, we need this
		
		symboltype(stri , symboltype* ptr = NULL, int width = 1);
};
typedef symboltype symtype;

class symboltable 
{ 					//For the Symbol Table Class, we have
	public:
		stri name;				//Name of the Table
		int count;					//Count of the temporary variables
		lstsym table; 			//The table of symbols which is essentially a list of sym
		symtable* parent;			//Parent ST of the current ST
		
		symtable (stri name="NULL");
		//Lookup for a symbol in ST
		s* lookup (stri);		
		//Print the ST						
		vd print();	
		//Update the ST				            			
		vd update();						        			
};

class quad 
{ 			//A single quad has four components:
	public:
		stri res;					// Result
		stri op;					// Operator
		stri arg1;				// Argument 1
		stri arg2;				// Argument 2

		//Print the Quad
		vd print();	
		vd type1();      //common printing types
		vd type2();

		//Constructors							
		quad (stri , stri , stri op = "=", stri arg2 = "");			
		quad (stri , int , stri op = "=", stri arg2 = "");							
};

class quadArray 
{ 		//Quad Array
	public:
		vec<quad> Array;		                    //Simply an Array (vector) of quads
		//Print the quadArray
		vd print();								
};

class basicType 
{                        //To denote a basic type
	public:
		vec<stri> type;                    //type name
		vec<int> size;                       //size
		vd addType(stri ,int );
};


extern symtable* ST;						// denotes the current Symbol Table
extern symtable* globalST;				    // denotes the Global Symbol Table
extern s* currSymbolPtr;					    // denotes the latest encountered symbol
extern quadArray Q;							// denotes the quad Array
extern basicType bt;                        // denotes the Type ST
extern long long int instr_count;			// denotes count of instr
extern bool debug_on;			// bool for printing debug output




stri convertIntToString(int );

vd generateSpaces(int );
//Different Attributes for Different Types and Extra Functions

s* gentemp (symboltype* , stri init = "");	  //generate a temporary variable and insert it in the current ST

//Emit Functions
vd emit(stri , stri , stri arg1="", stri arg2 = "");  
vd emit(stri , stri , int, stri arg2 = "");		    

//Backpatching and related functions
vd backpatch (list <int> , int );
listi makelist (int );							    // Make a new list contaninig an integer
listi merge (list<int> &l1, list <int> &l2);		// Merge two lists into a single list

int nextinstr();										// Returns the next instruction number
vd update_nextinstr();

vd debug();											// Used for printing debugging output
//Type checking and conversion functions


s* convertType(sym*, stri);								// for type conversion
bool compareSymbolType(sym* &s1, sym* &s2);				// check for same type of two symbol table entries
bool compareSymbolType(symboltype*, symboltype*);	// check for same type of two symboltype objects
int computeSize (symboltype *);						// calculate size of symbol type
stri printType(symboltype *);							// print type of symbol
vd changeTable (symtable* );



struct Statement {
	listi nextlist;					//nextlist for Statement
};

struct Array {
	stri atype;				//Used for type of Array: may be ptr or arr
	s* loc;					//Location used to compute address of Array
	s* Array;					//pointer to the symbol table entry
	symboltype* type;			//type of the subarr1 generated (important for multidimensional arr1s)
};

struct Expression {
	s* loc;								//pointer to the symbol table entry
	stri type; 							//to store whether the expression is of type int or bool or float or char
	listi truelist;						//fruelist for boolean expressions
	listi falselist;					//falselist for boolean expressions
	listi nextlist;						//for statement expressions
};
typedef Expression* Exps;
Exps convertIntToBool(Exps);				// convert int expression to boolean
Exps convertBoolToInt(Exps);				// convert boolean expression to int

#endif
