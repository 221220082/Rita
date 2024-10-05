%{
    #include <stdio.h>
    #include <string.h>
    #include "tree.h"
    #include "syntax.tab.h"
    int error_nums = 0;
    int yycolumn = 1;
    #define YY_USER_ACTION \
    yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column = yycolumn + yyleng -1; \
    yycolumn += yyleng;
%}
digit [0-9]
letter [_A-Za-z]
INT 0|([1-9]{digit}*)
FLOAT ({INT}[.]{digit}+)
FLOAT_E {digit}+{DOT}[eE][+-]?{digit}+
ID ([_A-Za-z])({letter}|{digit}|_)*
SEMI ";"
COMMA ","
ASSIGNOP "="
RELOP ">"|"<"|">="|"<="|"=="|"!="
STAR "*"
DIV "/"
PLUS "+"
MINUS "-"
AND "&&"
OR "||"
DOT "."
NOT "!"
TYPE "int"|"float"
LP "("
RP ")"
LB "["
RB "]"
LC "{"
RC "}"
STRUCT "struct"
RETURN "return"
IF "if"
ELSE "else"
WHILE "while"
SWITCH "switch"
WHITESPACE [ \t\r\n]+
delimiter [ \t\r]
%option yylineno
%%
{SEMI} {yylval.node=creatNode(0,"SEMI",TOKEN_OTHER,yylineno,yytext);return SEMI;}
{COMMA} {yylval.node=creatNode(0,"COMMA",TOKEN_OTHER,yylineno,yytext);return COMMA;}
{ASSIGNOP} {yylval.node=creatNode(0,"ASSIGNOP",TOKEN_OTHER,yylineno,yytext);return ASSIGNOP;}
{RELOP} {yylval.node=creatNode(0,"RELOP",TOKEN_OTHER,yylineno,yytext);return RELOP;}
{STAR} {yylval.node=creatNode(0,"STAR",TOKEN_OTHER,yylineno,yytext);return STAR;}
{DIV} {yylval.node=creatNode(0,"DIV",TOKEN_OTHER,yylineno,yytext);return DIV;}
{PLUS} {yylval.node=creatNode(0,"PLUS",TOKEN_OTHER,yylineno,yytext);return PLUS;}
{MINUS} {yylval.node=creatNode(0,"MINUS",TOKEN_OTHER,yylineno,yytext);return MINUS;}
{AND} {yylval.node=creatNode(0,"AND",TOKEN_OTHER,yylineno,yytext);return AND;}
{OR} {yylval.node=creatNode(0,"OR",TOKEN_OTHER,yylineno,yytext);return OR;}
{DOT} {yylval.node=creatNode(0,"DOT",TOKEN_OTHER,yylineno,yytext);return DOT;}
{NOT} {yylval.node=creatNode(0,"NOT",TOKEN_OTHER,yylineno,yytext);return NOT;}
{TYPE} {yylval.node=creatNode(0,"TYPE",TOKEN_TYPE,yylineno,yytext);return TYPE;}
{LP} {yylval.node=creatNode(0,"LP",TOKEN_OTHER,yylineno,yytext);return LP;}
{RP} {yylval.node=creatNode(0,"RP",TOKEN_OTHER,yylineno,yytext);return RP;}
{LB} {yylval.node=creatNode(0,"LB",TOKEN_OTHER,yylineno,yytext);return LB;}
{RB} {yylval.node=creatNode(0,"RB",TOKEN_OTHER,yylineno,yytext);return RB;}
{LC} {yylval.node=creatNode(0,"LC",TOKEN_OTHER,yylineno,yytext);return LC;}
{RC} {yylval.node=creatNode(0,"RC",TOKEN_OTHER,yylineno,yytext);return RC;}
{STRUCT} {yylval.node=creatNode(0,"STRUCT",TOKEN_OTHER,yylineno,yytext);return STRUCT;}
{RETURN} {yylval.node=creatNode(0,"RETURN",TOKEN_OTHER,yylineno,yytext);return RETURN;}
{IF} {yylval.node=creatNode(0,"IF",TOKEN_OTHER,yylineno,yytext);return IF;}
{ELSE} {yylval.node=creatNode(0,"ELSE",TOKEN_OTHER,yylineno,yytext);return ELSE;}
{WHILE} {yylval.node=creatNode(0,"WHILE",TOKEN_OTHER,yylineno,yytext);return WHILE;}
{SWITCH} {yylval.node=creatNode(0,"SWITCH",TOKEN_OTHER,yylineno,yytext);return SWITCH;}
{INT} {yylval.node=creatNode(0,"INT",TOKEN_INT,yylineno,yytext);return INT;}
{FLOAT} {yylval.node=creatNode(0,"FLOAT",TOKEN_FLOAT,yylineno,yytext);return FLOAT;}
{FLOAT_E} {yylval.node=creatNode(0,"FLOAT_E",TOKEN_FLOAT_E,yylineno,yytext);return FLOAT_E;}
{ID} {yylval.node=creatNode(0,"ID",TOKEN_ID,yylineno,yytext);return ID;}
\n { yycolumn = 1; }
{WHITESPACE} {;}
. { 
    error_nums+=1;
    printf("ERROR A at line %d : Mysterious characters \
\'%s\'\n",yylineno,yytext); 
}
%%
