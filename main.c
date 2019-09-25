#include<stdio.h>

extern int yylex (void);
extern FILE* yyin;
extern void my_test_function(void);

int main(int argc, char** argv) {
    if(argc > 1) {
        if (!(yyin = fopen(argv[1], "r"))) {
            printf("Can not open file %s\n",argv[1]);
            return -1;
        }
    }
    else {
        printf("pass filename to scanner\n");
        return -1;
    }
    while(yylex() != 0){}
    return 0;
}