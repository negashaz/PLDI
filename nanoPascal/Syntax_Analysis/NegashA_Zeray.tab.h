
/* A Bison parser, made by GNU Bison 2.4.1.  */

/* Skeleton interface for Bison's Yacc-like parsers in C
   
      Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.
   
   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     PROGRAM = 258,
     FUNCTION = 259,
     VAR = 260,
     INTEGER = 261,
     STRING = 262,
     WHILE = 263,
     DO = 264,
     IF = 265,
     THEN = 266,
     ELSE = 267,
     EGIN = 268,
     END = 269,
     IDENTIFIER = 270,
     INTEGER_CONSTANT = 271,
     STRING_LITERAL = 272,
     LESS_THAN = 273,
     GREATER_THAN = 274,
     LESS_THAN_EQUAL = 275,
     GREATER_THAN_EQUAL = 276,
     EQUAL = 277,
     NOT_EQUAL = 278,
     ASSIGNMENT = 279,
     LEFT_PARENTHESIS = 280,
     RIGHT_PARENTHESIS = 281,
     COMMA = 282,
     SEMICOLON = 283,
     PERIOD = 284,
     COLON = 285,
     PLUS = 286,
     MINUS = 287,
     ASTERISK = 288,
     SLASH = 289
   };
#endif



#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 1676 of yacc.c  */
#line 12 "NegashA_Zeray.y"

    int ival;
    char *sval;




/* Line 1676 of yacc.c  */
#line 94 "NegashA_Zeray.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


