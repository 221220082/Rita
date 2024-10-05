%locations
%{
    #include <string.h>
    #include <stdlib.h>
    #include "tree.h"
    #include "lex.yy.c"
    struct Node* root = NULL;
    extern void yyerror(const char *msg);
%}
/* declared yylval's types */
%union {
    struct Node* node;
}
/* declared tokens */
%token <node> INT
%token <node> FLOAT
%token <node> FLOAT_E
%token <node> ID
%token <node> SEMI
%token <node> COMMA
%token <node> ASSIGNOP
%token <node> RELOP
%token <node> PLUS
%token <node> MINUS
%token <node> STAR
%token <node> DIV
%token <node> AND
%token <node> OR
%token <node> DOT
%token <node> NOT
%token <node> TYPE
%token <node> LP
%token <node> RP
%token <node> LB
%token <node> RB
%token <node> LC
%token <node> RC
%token <node> STRUCT
%token <node> RETURN
%token <node> IF
%token <node> ELSE
%token <node> WHILE
%token <node> SWITCH

%type <node> Program
%type <node> ExtDefList
%type <node> ExtDef
%type <node> ExtDecList
%type <node> Specifier
%type <node> StructSpecifier
%type <node> OptTag
%type <node> Tag
%type <node> VarDec
%type <node> FunDec
%type <node> VarList
%type <node> ParamDec
%type <node> CompSt
%type <node> StmtList
%type <node> Stmt
%type <node> Def
%type <node> DecList
%type <node> DefList
%type <node> Dec
%type <node> Exp
%type <node> Args

%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP LB RB DOT 

%nonassoc LOWER_ELSE
%nonassoc ELSE
%%
//High-level Definitions
Program : ExtDefList
{
    root=creatNode(1,"Program",TYPE_NULL,@$.first_line,NULL);
    $$=root;
    insert($$,$1);
}
;
ExtDefList : ExtDef ExtDefList
{
    $$=creatNode(1,"ExtDefList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
/*empty*/{$$=NULL;}
;
ExtDef : Specifier ExtDecList SEMI
{
    $$=creatNode(1,"ExtDef",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Specifier SEMI
{
    $$=creatNode(1,"ExtDef",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
Specifier FunDec CompSt
{
    $$=creatNode(1,"ExtDef",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|error SEMI{printf("%d:Missing Type or Wrong Type.\n",@1.first_line);}
|Specifier error{printf("%d:Missing ;\n",@1.last_line);}
|error CompSt{printf("%d:Missing Type or Wrong Type\n",@1.first_line);}
;
ExtDecList : VarDec
{
    $$=creatNode(1,"ExtDecList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
VarDec COMMA ExtDecList
{
    $$=creatNode(1,"ExtDecList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|VarDec error ExtDecList{printf("%d:Missing ,\n",@2.first_line);}
;
//Specifiers
Specifier : TYPE
{
    $$=creatNode(1,"Specifier",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
} 
|
StructSpecifier
{
    $$=creatNode(1,"Specifier",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
;
StructSpecifier : STRUCT OptTag LC DefList RC
{
    $$=creatNode(1,"StructSpecifier",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
    insert($$,$5);
}
|
STRUCT Tag
{
    $$=creatNode(1,"StructSpecifier",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|STRUCT OptTag LC error RC{printf("%d:Wrong Def\n",@4.first_line);}
|STRUCT OptTag error RC{printf("%d:Missing {",@3.first_line);}
|STRUCT error LC DefList RC{printf("%d:Wrong name\n",@2.first_line);}
|error OptTag LC DefList RC{printf("%d:Wrong Type\n",@1.first_line);}
;
OptTag : ID
{
    $$=creatNode(1,"OptTag",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
/*empty*/{$$=NULL;}
;
Tag : ID
{
    $$=creatNode(1,"Tag",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
;
//Declarators
VarDec : ID
{
    $$=creatNode(1,"VarDec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
VarDec LB INT RB
{
    $$=creatNode(1,"VarDec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
}
|VarDec LB error RB{printf("%d:Wrong ;\n",@3.first_line);}
|error RB{printf("%d:Wrong ;\n",@1.first_line);}
;
FunDec : ID LP VarList RP
{
    $$=creatNode(1,"FunDec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
}
|
ID LP RP
{
    $$=creatNode(1,"FunDec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|ID LP error RP{printf("%d:Wrong ;\n",@3.first_line);}
|ID error RP{printf("%d:Wrong ;\n",@2.first_line);}
|error LP VarList RP{printf("%d:Wrong ;\n",@1.first_line);}
;
VarList : ParamDec COMMA VarList
{
    $$=creatNode(1,"VarList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
ParamDec
{
    $$=creatNode(1,"VarList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
; 
ParamDec : Specifier VarDec
{
    $$=creatNode(1,"ParamDec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
;
//Statements
CompSt : LC DefList StmtList RC
{
    $$=creatNode(1,"CompSt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
}
|LC error RC{printf("%d:Wrong ;\n",@2.first_line);}
;
StmtList : Stmt StmtList
{
    $$=creatNode(1,"StmtList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
/*empty*/{$$=NULL;}
;
Stmt : Exp SEMI
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
CompSt
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
RETURN Exp SEMI
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
IF LP Exp RP Stmt %prec LOWER_ELSE
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
    insert($$,$5);

}
|
IF LP Exp RP Stmt ELSE Stmt
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
    insert($$,$5);
    insert($$,$6);
    insert($$,$7);
}
|
WHILE LP Exp RP Stmt
{
    $$=creatNode(1,"Stmt",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
    insert($$,$5);
}
|error SEMI{printf("%d:Wrong ;\n",@1.first_line);}
|RETURN Exp error{printf("%d:Wrong ;\n",@2.last_line);}
|RETURN error SEMI{printf("%d:Wrong ;\n",@2.first_line);}
|IF error RP ELSE Stmt{printf("%d:Wrong ;\n",@2.first_line);}
|IF LP error ELSE Stmt{printf("%d:Wrong ;\n",@3.first_line);}
|WHILE error RP Stmt{printf("%d:Wrong ;\n",@2.first_line);}

;
//Local Definitions

DefList : Def DefList
{
    $$=creatNode(1,"DefList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
/*empty*/{$$=NULL;}
;
Def : Specifier DecList SEMI
{
    $$=creatNode(1,"Def",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|Specifier error SEMI{printf("%d:Wrong ;\n",@2.first_line);}
|error DecList SEMI{printf("%d:Wrong ;\n",@1.first_line);}

;
DecList : Dec
{
    $$=creatNode(1,"DecList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
Dec COMMA DecList
{
    $$=creatNode(1,"DecList",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|Dec error DecList{printf("%d:Wrong ;\n",@2.first_line);}
|Dec error{printf("%d:Wrong ;\n",@1.last_line);}
;
Dec : VarDec
{
    $$=creatNode(1,"Dec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
VarDec ASSIGNOP Exp
{
    $$=creatNode(1,"Dec",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|VarDec ASSIGNOP error{printf("%d:Wrong ;\n",@3.first_line);}
;
//Expressions
Exp : Exp ASSIGNOP Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp AND Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp OR Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp RELOP Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp PLUS Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp MINUS Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp STAR Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp DIV Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
LP Exp RP
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
MINUS Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
NOT Exp
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
}
|
ID LP Args RP
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
}
|
ID LP RP
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp LB Exp RB
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
    insert($$,$4);
}
|
Exp LB Exp error RB
{
    printf("%d:Missing ]\n",@4.first_line);
}
|
Exp DOT ID
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
ID
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
INT
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|
FLOAT
{
    $$=creatNode(1,"Exp",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
|Exp ASSIGNOP error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp AND error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp OR error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp RELOP error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp PLUS error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp MINUS error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp STAR error{printf("%d:Wrong ;\n",@3.first_line);}
|Exp DIV error{printf("%d:Wrong ;\n",@3.first_line);}
|LP error RP{printf("%d:Wrong ;\n",@2.first_line);}
|MINUS error{printf("%d:Wrong ;\n",@2.first_line);}
|NOT error{printf("%d:Wrong ;\n",@2.first_line);}
|ID LP error RP{printf("%d:Wrong ;\n",@3.first_line);}
|ID LP error{printf("%d:Wrong ;\n",@2.last_line);}
|Exp LB error RB{printf("%d:Wrong ;\n",@3.first_line);}
|Exp LB error{printf("%d:Wrong ;\n",@2.last_line);}
;
Args : Exp COMMA Args
{
    $$=creatNode(1,"Args",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
    insert($$,$2);
    insert($$,$3);
}
|
Exp
{
    $$=creatNode(1,"Args",TYPE_NULL,@$.first_line,NULL);
    insert($$,$1);
}
;
%%