%{
#include <stdio.h>
#include "lex.yy.c"
#include "grammarTree.h"

Morpheme* root = NULL;

#ifndef YYSTYPE
#define YYSTYPE Morpheme*
#endif

%}
/*定义类型*/

/*定义tokens*/
%token INT
%token FLOAT
%token ID
%token SEMI
%token COMMA
%token ASSIGNOP
%token RELOP
%token PLUS MINUS STAR DIV
%token AND OR NOT
%token DOT
%token TYPE
%token LP RP LB RB LC RC
%token STRUCT
%token RETURN
%token IF
%token ELSE
%token WHILE
/*定义非终结符号*/

/*结合规则*/
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left DOT LP RP LB RB


/*定义产生式规则*/
%%
Program : ExtDefList {$$=createMorpheme(_Program);nodeGrowth($$,1,$1);root=$$;}
    ;
ExtDefList : /*empty*/ {$$=createMorpheme(_ExtDefList);nodeGrowth($$,1,createMorpheme(_BLANK));}
    | ExtDef ExtDefList {$$=createMorpheme(_ExtDefList);nodeGrowth($$, 2, $1, $2);}
    ;
ExtDef : Specifier ExtDecList SEMI {$$=createMorpheme(_ExtDef);nodeGrowth($$, 3, $1, $2, $3);}
    | Specifier SEMI   {$$=createMorpheme(_ExtDef); nodeGrowth($$, 2, $1, $2);}
    | Specifier FunDec CompSt   {$$=createMorpheme(_ExtDef); nodeGrowth($$, 3, $1, $2, $3);}
    ;
ExtDecList : VarDec {$$=createMorpheme(_ExtDecList); nodeGrowth($$, 1, $1);}
    | VarDec COMMA ExtDecList   {$$=createMorpheme(_ExtDecList); nodeGrowth($$, 3, $1, $2, $3);}
    ;
Specifier : TYPE    {$$=createMorpheme(_Specifier); nodeGrowth($$, 1, $1);}
    | StructSpecifier   {$$=createMorpheme(_Specifier); nodeGrowth($$, 1, $1);}
    ;
StructSpecifier : STRUCT OptTag LC DefList RC   {$$=createMorpheme(_StructSpecifier); nodeGrowth($$, 5, $1, $2, $3, $4, $5);}
    | STRUCT Tag    {$$=createMorpheme(_StructSpecifier); nodeGrowth($$, 2, $1, $2);}
    ;
OptTag : /*empty*/  {$$=createMorpheme(_OptTag); nodeGrowth($$, 1, createMorpheme(_BLANK));}
    | ID    {$$=createMorpheme(_OptTag); nodeGrowth($$, 1, $1);}
    ;
Tag : ID    {$$=createMorpheme(_Tag); nodeGrowth($$, 1, $1);}
    ;
VarDec : ID {$$=createMorpheme(_VarDec); nodeGrowth($$, 1, $1);}
    | VarDec LB INT RB  {$$=createMorpheme(_VarDec); nodeGrowth($$, 4, $1, $2, $3, $4);}
    ;
FunDec : ID LP VarList RP   {$$=createMorpheme(_FunDec); nodeGrowth($$, 4, $1, $2, $3, $4);}
    | ID LP RP  {$$=createMorpheme(_FunDec); nodeGrowth($$, 3, $1, $2, $3);}
    ;
VarList : ParamDec COMMA VarList    {$$=createMorpheme(_VarList); nodeGrowth($$, 3, $1, $2, $3);}
    | ParamDec  {$$=createMorpheme(_VarList); nodeGrowth($$, 1, $1);}
    ;
ParamDec : Specifier VarDec {$$=createMorpheme(_ParamDec); nodeGrowth($$, 2, $1, $2);}
    ;
CompSt : LC DefList StmtList RC {$$=createMorpheme(_CompSt); nodeGrowth($$, 4, $1, $2, $3, $4);}
    ;
StmtList : /*empty*/    {$$=createMorpheme(_StmtList); nodeGrowth($$, 1, createMorpheme(_BLANK));}
    | Stmt StmtList {$$=createMorpheme(_StmtList); nodeGrowth($$, 2, $1, $2);}
    ;
Stmt : Exp SEMI {$$=createMorpheme(_Stmt); nodeGrowth($$, 2, $1, $2);}
    | CompSt    {$$=createMorpheme(_Stmt); nodeGrowth($$, 1, $1);}
    | RETURN Exp SEMI   {$$=createMorpheme(_Stmt); nodeGrowth($$, 3, $1, $2, $3);}
    | IF LP Exp RP Stmt {$$=createMorpheme(_Stmt); nodeGrowth($$, 5, $1, $2, $3, $4, $5);}
    | IF LP Exp RP Stmt ELSE Stmt   {$$=createMorpheme(_Stmt); nodeGrowth($$, 7, $1, $2, $3, $4, $5, $6, $7);}
    | WHILE LP Exp RP Stmt  {$$=createMorpheme(_Stmt); nodeGrowth($$, 5, $1, $2, $3, $4, $5);}
    ;
DefList : /*empty*/ {$$=createMorpheme(_DefList); nodeGrowth($$, 1, createMorpheme(_BLANK));}
    | Def DefList   {$$=createMorpheme(_DefList); nodeGrowth($$, 2, $1, $2);}
    ;
Def : Specifier DecList SEMI    {$$=createMorpheme(_Def); nodeGrowth($$, 3, $1, $2, $3);}
    ;
DecList : Dec   {$$=createMorpheme(_DefList); nodeGrowth($$, 1, $1);}
    | Dec COMMA DecList {$$=createMorpheme(_DefList); nodeGrowth($$, 3, $1, $2, $3);}
    ;
Dec : VarDec    {$$=createMorpheme(_Dec); nodeGrowth($$, 1, $1);}
    | VarDec ASSIGNOP Exp   {$$=createMorpheme(_Dec); nodeGrowth($$, 3, $1, $2, $3);}
    ;
Exp : Exp ASSIGNOP Exp  {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp AND Exp   {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp OR Exp    {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp RELOP Exp {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp PLUS Exp  {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp MINUS Exp {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp STAR Exp  {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp DIV Exp   {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | LP Exp RP {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | MINUS Exp {$$=createMorpheme(_Exp); nodeGrowth($$, 2, $1, $2);}
    | NOT Exp   {$$=createMorpheme(_Exp); nodeGrowth($$, 2, $1, $2);}
    | ID LP Args RP {$$=createMorpheme(_Exp); nodeGrowth($$, 4, $1, $2, $3, $4);}
    | ID LP RP  {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp LB Exp RB {$$=createMorpheme(_Exp); nodeGrowth($$, 4, $1, $2, $3, $4);}
    | Exp DOT ID    {$$=createMorpheme(_Exp); nodeGrowth($$, 3, $1, $2, $3);}
    | ID    {$$=createMorpheme(_Exp); nodeGrowth($$, 1, $1);}
    | INT   {$$=createMorpheme(_Exp); nodeGrowth($$, 1, $1);}
    | FLOAT {$$=createMorpheme(_Exp); nodeGrowth($$, 1, $1);}
    ;
Args : Exp COMMA Args   {$$=createMorpheme(_Args); nodeGrowth($$, 3, $1, $2, $3);}
    | Exp   {$$=createMorpheme(_Args); nodeGrowth($$, 1, $1);}
    ;

%%

