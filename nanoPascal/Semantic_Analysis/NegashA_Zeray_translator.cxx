#include "NegashA_Zeray_translator.h"

#include<sstream>
#include<string>
#include<iostream>
using namespace std;

symboltable* globalST;
quadArray Q_array;
string var_type;
symboltable* ST;
symbol* currSymbolPtr;
basicType btype;
long long int instr_count;
bool debug_on;

void printpattern(){cout<<"";}

sym::sym(string name, string t, symboltype* arrtype, int width) 
{     
    (*this).name=name;
    type=new symboltype(t,arrtype,width);
    size=computeSize(type);
    offset=0;
    val="-";
    nested=NULL;
}

symbol* sym::update(symboltype* t) 
{
    type=t;
    (*this).size=computeSize(t);
    return this;
}

symboltype::symboltype(string type,symboltype* arrtype,int width)        
{
    (*this).type=type;
    (*this).width=width;
    (*this).arrtype=arrtype;
}

symtable::symtable(string name)            
{
    (*this).name=name;
    count=0;
}

symbol* symtable::lookup(string name)               
{
    symbol* symbol;
    lsit it;
    it=table.begin();
    while(it!=table.end()) 
    {
        if(it->name==name) 
            return &(*it);
        it++;
    }
    symbol= new sym(name);
    table.push_back(*symbol);
    return &table.back();
}

void symtable::update()                      
{
    list<symboltable*> tb;
    int off;
    lsit it;
    it=table.begin();
    while(it!=table.end()) 
    {
        if(it==table.begin()) 
        {
            it->offset=0;
            off=it->size;
        }
        else 
        {
            it->offset=off;
            off=it->offset+it->size;
        }
        if(it->nested!=NULL) 
            tb.push_back(it->nested);
        it++;
    }
    list<symboltable*>::iterator it1;
    it1=tb.begin();
    while(it1 !=tb.end()) 
    {
      (*it1)->update();
      it1++;
    }
}

void symtable::print()                            
{
    int next_instr=0;
    list<symboltable*> tb;
    for(int t1=0;t1<50;t1++) 
        cout<<"--";
    cout<<endl;

    cout<<"ST:<Table Name>, "<<(*this).name<<"\tParent Name: ";
    if(((*this).parent==NULL))
        cout<<"NULL"<<endl;
    else
        cout<<(*this).parent->name<<endl; 
    for(int ti=0;ti<50;ti++) 
        cout<<"--";
    cout<<endl;

    cout<<"<name>,";
    generateSpaces(11);
    cout<<"<type>,";
    generateSpaces(16);
    cout<<"<size>";
    generateSpaces(11);
    cout<<"Nested"<<endl;
    generateSpaces(100);
    cout<<endl;

    ostringstream str1;
     
    for(lsit it=table.begin(); it!=table.end(); it++) {
        
        cout<<it->name;
        generateSpaces(15-it->name.length());
        string typeres=print_type(it->type);
        cout<<typeres;
        generateSpaces(20-it->val.length());
        cout<<it->size;
        str1<<it->size;
        generateSpaces(15-str1.str().length());
        str1.str("");
        str1.clear();
        if(it->nested==NULL) {
            cout<<"NULL"<<endl;	
        }
        else {
            cout<<it->nested->name<<endl;
            tb.push_back(it->nested);
        }
    }
    
    for(int i=0;i<50;i++) 
        cout<<"-";
    cout<<"\n\n";
    for(list<symboltable*>::iterator it=tb.begin(); it !=tb.end();++it) 
    {
        (*it)->print();
    }
            
}

quad::quad(string res,string arg1,string op,string arg2)           
{
    (*this).res=res;
    (*this).arg1=arg1;
    (*this).op=op;
    (*this).arg2=arg2;
}

quad::quad(string res,int arg1,string op,string arg2)             
{
    (*this).res=res;
    (*this).arg2=arg2;
    (*this).op=op;
    (*this).arg1=convertIntToString(arg1);
}

void quad::print() 
{                                    
    int next_instr=0;	
    if(op=="+")
    {	
        (*this).type1();
    }
    else if(op=="-")
    {				
        (*this).type1();
    }
    else if(op=="*")
    {
        (*this).type1();
    }
    else if(op=="/")
    {	
        (*this).type1();
    }
    else if(op=="==")
    {
        (*this).type2();
    }
    else if(op=="!=")
    {
        (*this).type2();
    }
    else if(op=="<=")
    {
        (*this).type2();
    }
    else if(op=="<")
    {	
        (*this).type2();
    }
    else if(op==">")
    {
        (*this).type2();
    }
    else if(op==">=")
    {
        (*this).type2();
    }
    else if(op=="goto")
    {
        cout<<"goto "<<res;
    }					
    else if(op=="=&")
    {
        cout<<res<<" &"<<arg1;
    }
    else if(op=="&")
    {
        cout<<res<<" +"<<arg1 ;
    }
    
    else if(op=="uminus")
    {
        cout<<res<<" = -"<<arg1;
    }
    else if(op=="return")
    {
        cout<<"return "<<res;
    }
    else if(op=="param")
    {
        cout<<"param "<<res;
    }
    else if(op=="call")
    {
        cout<<res<<" = "<<"call "<<arg1<<", "<<arg2;
    }	
    else
    {	
        cout<<"Can't find "<<op;
    }			
    cout<<endl;
    
}

void quad::type1()
{
    cout<<res<<" = "<<arg1<<" "<<op<<" "<<arg2;
}

void quad::type2()
{
    cout<<"if "<<arg1<< " "<<op<<" "<<arg2<<" goto "<<res;
}

void basicType::add_type(string t, int s)          
{
    type.push_back(t);
    size.push_back(s);
}

quadArray::print()                                   
{
    for(int i=0;i<50;i++) 
        cout<<"--";
    cout<<endl;
    cout<<"Three Address Code:"<<endl;
    for(int i=0;i<50;i++) 
        cout<<"-";
    cout<<endl;
    int j=0;
    vector<quad>::iterator it;
    for(int i=0;i<50;i++) 
        cout<<"__";
    cout<<endl;
}

void generateSpaces(int n)
{
    while(n--) 
        cout<<" ";
}

string convertIntToString(int a)                    
{
    stringstream strs;
    strs<<a; 
    string temp=strs.str();
    char* integer=(char*) temp.c_str();
    string str=string(integer);
    return str;
}

void emit(string op, string res, string arg1, string arg2) 
{             
    quad *q1= new quad(res,arg1,op,arg2);
    Q.Array.push_back(*q1);
}

void emit(string op, string res, int arg1, string arg2) 
{                 
    quad *q2= new quad(res,arg1,op,arg2);
    Q.Array.push_back(*q2);
}

symbol* convertType(symbol* s, string rettype) 
{                             
    symbol* temp=gentemp(new symboltype(rettype));	
    
    if((*s).type->type=="int")                                  
    {
        if(rettype=="char") 								
        {
            emit("=",temp->name,"int2char("+(*s).name+")");
            return temp;
        }
        return s;
    }
    else if((*s).type->type=="char") 								  
    {
        if(rettype=="int") 									
        {
            emit("=",temp->name,"char2int("+(*s).name+")");
            return temp;
        }
        return s;
    }
    return s;
}

void changeTable(symboltable* newtable) 
{	       
    ST = newtable;
} 

bool compareSymbolType(symbol*& s1,symbol*& s2)
{ 	
    symboltype* type1=s1->type;
    symboltype* type2=s2->type;
    int flag=0;
    if(compareSymbolType(type1,type2)) 
        flag=1;       
    else if(s1=convertType(s1,type2->type)) 
        flag=1;
    else if(s2=convertType(s2,type1->type)) 
        flag=1;
    if(flag)
        return true;
    else 
        return false;
}

bool compareSymbolType(symboltype* t1,symboltype* t2)
{ 	
    int flag=0;
    if(t1==NULL && t2==NULL) 
        flag=1;               
    else if(t1==NULL || t2==NULL || t1->type!=t2->type) 
        flag=2;                     

    if(flag==1)
        return true;
    else if(flag==2)
        return false;
    else 
        return compareSymbolType(t1->arrtype,t2->arrtype);
}

void backpatch(list<int> list1,int addr)                 
{
    string str=convertIntToString(addr);
    list<int>::iterator it;
    it=list1.begin();
    while( it!=list1.end()) 
    {
        Q.Array[*it].res=str;
        it++;
    }
}

list<int> makelist(int init) 
{
    list<int> newlist(1,init);
    return newlist;
}

list<int> merge(list<int> &a,list<int> &b)
{
    a.merge(b);
    return a;
}

Expression* convertIntToBool(Expression* e)        
{
    if(e->type!="bool")                
    {
        e->falselist=makelist(nextinstr());
        emit("==","",e->loc->name,"0");
        e->truelist=makelist(nextinstr());
        emit("goto","");
    }
}

void update_nextinstr()
{
    instr_count++;
    if(debug_on==1)
    {
        cout<<"Line number"<<instr_count<<endl;
        cout<<"Continue?";
        cin.get();
    }
}

void debug()
{
    if(debug_on==1)
        cout<<instr_count<<endl;
}

Expression* convertBoolToInt(Expression* e) 
{
    if(e->type=="bool") 
    {
        e->loc=gentemp(new symboltype("int"));
        backpatch(e->truelist,nextinstr());
        emit("=",e->loc->name,"true");
        int p=nextinstr()+1;
        string str=convertIntToString(p);
        emit("goto",str);
        backpatch(e->falselist,nextinstr());
        emit("=",e->loc->name,"false");
    }
}

int nextinstr() 
{
    return Q.Array.size();
}

symbol* gentemp(symboltype* t, string str_new) 
{         
    string tmp_name = "t"+convertIntToString(ST->count++);             
    symbol* s = new sym(tmp_name);
    (*s).type = t;
    (*s).size=computeSize(t);                        
    (*s).val = str_new;
    ST->table.push_back(*s);                        
    return &ST->table.back();
}

int computeSize(symboltype* t)                   
{
    if(t->type.compare("void")==0)	return btype.size[1];
    else if(t->type.compare("char")==0) return btype.size[2];
    else if(t->type.compare("int")==0) return btype.size[3];
    else if(t->type.compare("func")==0) return btype.size[4];
    else 
        return -1;
}

string print_type(symboltype* t)     
{
    if(t==NULL) return btype.type[0];
    if(t->type.compare("void")==0)	return btype.type[1];
    else if(t->type.compare("char")==0) return btype.type[2];
    else if(t->type.compare("int")==0) return btype.type[3];
    else if(t->type.compare("func")==0) return btype.type[4];
    else return "NULL";
}

int main()
{
    btype.add_type("null",0);
    btype.add_type("void",0);
    btype.add_type("char",4);
    btype.add_type("int",4);
    btype.add_type("func",0);

    instr_count = 0;   
    debug_on= 0;   

    globalST=new symtable("Global");                         
    ST=globalST;
    yyparse();												 
    globalST->update();										 
    cout<<"\n";
    Q_Array.print();	
    globalST->print();										
};
