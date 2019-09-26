/* flex源文件由3部分构成，用%%分开*/
%{
#include <stdlib.h>
#include "syntax.tab.h"    
void discard_comment();
%}
/*定义部分*/
/*Flex采用最长规则进行匹配*/
%option yylineno
Exp_float [+-]?(([0-9]+\.[0-9]*)|([0-9]*\.[0-9]+))([eE][+-]?[0-9]+)
Float [+-]?([0-9]+\.[0-9]+)
Dec_number [+-]?(([1-9][0-9]*)|0) 
Oct_number [+-]?0[0-7]+
Hex_number [+-]?0[Xx][0-9a-fA-F]+
Type (int)|(float)
Struct struct
Return return
If if
Else else
While while
ID [_a-zA-Z][_a-zA-Z0-9]*
Semi ;
Comma ,
Assign_op =
Rel_op (>)|(<)|(>=)|(<=)|(==)|(!=)
Plus \+
Minus -
Star \*
Div \/
And &&
Or \|\|
Dot \.
Not !
Lp \(
Rp \)
Lb \[
Rb \]
Lc \{
Rc \}
Blank [ \t]+
OneLineComment \/\/[^\n]*
MultiLineComment \/\* 
/*规则部分: 定义匹配时采取的动作*/
/*越靠前优先级越高，匹配时按照贪心的原则进行，所以关键字如int float 应该放在前面*/
%%
{OneLineComment} {printf("Line %d: match a oneline comment: %s\n", yylineno, yytext);}
{MultiLineComment} {discard_comment();discard_comment(); printf("Line %d: match multiline comment: %s\n", yylineno, yytext);} //调用自定义的多行注释处理器
{Exp_float} { printf("Line %d: match a exp_float: %s\n", yylineno, yytext);return FLOAT;}
{Float} {printf("Line %d: match a float: %s\n", yylineno, yytext);return FLOAT;}
{Dec_number} {printf("Line %d: match a dec number: %s\n", yylineno, yytext); return INT;}
{Oct_number} { printf("Line %d: match an oct number: %s\n", yylineno, yytext);return INT;}
{Hex_number} { printf("Line %d: match a hex number: %s\n", yylineno, yytext);return INT;}
{Type} {printf("Line %d: match a type: %s\n", yylineno, yytext);return TYPE;}
{Struct} {printf("Line %d: match a struct: %s\n", yylineno, yytext);return STRUCT;}
{Return} {printf("Line %d: match a return: %s\n", yylineno, yytext);return RETURN;}
{If} {printf("Line %d: match a if: %s\n", yylineno, yytext);return IF;}
{Else} {printf("Line %d: match a else: %s\n", yylineno, yytext);return ELSE;} 
{While} {printf("Line %d: match a while: %s\n", yylineno, yytext);return WHILE; }
{ID} {printf("Line %d: match a id: %s\n", yylineno, yytext);return ID;}
{Semi} {printf("Line %d: match a semi: %s\n", yylineno, yytext);return SEMI;}
{Comma} {printf("Line %d: match a comma: %s\n", yylineno, yytext);return COMMA;}
{Assign_op} {printf("Line %d: match a assignop: %s\n", yylineno, yytext);return ASSIGNOP;}
{Rel_op} {printf("Line %d: match a relop: %s\n", yylineno, yytext);return RELOP;}
{Plus} {printf("Line %d: match a plus: %s\n", yylineno, yytext);return PLUS;}
{Minus} {printf("Line %d: match a minus: %s\n", yylineno, yytext);return MINUS;}
{Star} {printf("Line %d: match a start: %s\n", yylineno, yytext);return STAR;}
{Div} {printf("Line %d: match a div: %s\n", yylineno, yytext);return DIV;}
{And} {printf("Line %d: match a and: %s\n", yylineno, yytext);return AND;} 
{Or} {printf("Line %d: match a or: %s\n", yylineno, yytext);return OR;} 
{Dot} {printf("Line %d: match a dot: %s\n", yylineno, yytext);return DOT;}
{Not} {printf("Line %d: match a not: %s\n", yylineno, yytext);return NOT;}
{Lp} {printf("Line %d: match a lp: %s\n", yylineno, yytext);return LP;}
{Rp} {printf("Line %d: match a rp: %s\n", yylineno, yytext);return RP;}
{Lb} {printf("Line %d: match a lb: %s\n", yylineno, yytext);return LB;}
{Rb} {printf("Line %d: match a rb: %s\n", yylineno, yytext);return RB;}
{Lc} {printf("Line %d: match a lc: %s\n", yylineno, yytext);return LC;}
{Rc} {printf("Line %d: match a rc: %s\n", yylineno, yytext);return RC;}
{Blank} {} //忽略空格和tab
. {printf("Error type A at Line %d: mysterious characters \'%s\' \n", yylineno, yytext);} //对于未定义字符报错处理
\n {} //添加该规则以启用yylineno

%%
/*用户自定义代码*/
//丢弃多行注释
void discard_comment() {
    char c1, c2;
    while(1) {
        c1 = input();
        while(c1 != '*') {c1 = input();}
        c2 = input();
        if(c2 == '/') {
            break;
        }
    }
}
/* SLT ADD A COMMENT */