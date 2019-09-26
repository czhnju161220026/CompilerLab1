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
{OneLineComment} {}
{MultiLineComment} {discard_comment();} //调用自定义的多行注释处理器
{Exp_float} { return FLOAT;}
{Float} {return FLOAT;}
{Dec_number} { return INT;}
{Oct_number} { return INT;}
{Hex_number} { return INT;}
{Type} {return TYPE;}
{Struct} {return STRUCT;}
{Return} {return RETURN;}
{If} {return IF;}
{Else} {return ELSE;} 
{While} {return WHILE; }
{ID} {return ID;}
{Semi} {return SEMI;}
{Comma} {return COMMA;}
{Assign_op} {return ASSIGNOP;}
{Rel_op} {return RELOP;}
{Plus} {return PLUS;}
{Minus} {return MINUS;}
{Star} {return STAR;}
{Div} {return DIV;}
{And} {return AND;} 
{Or} {return OR;} 
{Dot} {return DOT;}
{Not} {return NOT;}
{Lp} {return LP;}
{Rp} {return RP;}
{Lb} {return LB;}
{Rb} {return RB;}
{Lc} {return LC;}
{Rc} {return RC;}
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