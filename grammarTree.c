#include "grammarTree.h"

const char *const TYPES_NAME_TABLE[] = 
{
    /*0 Blank*/
	"BLANK",
	/*1 Tokens*/
	"SEMI","COMMA","ASSIGNOP","RELOP",
	"PLUS","MINUS","STAR","DIV",
	"AND","OR","DOT","NOT","TYPE",
	"LP","RP","LB","RB","LC","RC",
	"STRUCT","RETURN","IF","ELSE","WHILE",
	"ID","INT","FLOAT",
	/*2 High-level Definitions*/
	"Program","ExtDefList","ExtDef","ExtDecList",
	/*3 Specifiers*/
	"Specifier","StructSpecifier","OptTag","Tag",
	/*4 Declarators*/
	"VarDec","FunDec","VarList","ParamDec",
	/*5 Statements*/
	"CompSt","StmtList","Stmt",
	/*6 Local Definitions*/
	"DefList","Def","DecList","Dec",
	/*7 Expressions*/
	"Exp","Args"
};

Morpheme* createMorpheme(Types type) {
    Morpheme* morpheme = (Morpheme*) malloc(sizeof(Morpheme));
    if (morpheme == NULL) {
        printf("Memory alloc error\n");
        exit(0);
    }

    morpheme->type = type;
    morpheme->father = NULL;
    morpheme->lineNumber = -1;
    for (int i = 0; i < MAX_CHILDREN_NUMBER; i++) {
        morpheme->children[i] = NULL;
    }

    return morpheme;
}

void addChild(Morpheme* father, Morpheme* child, int i) {
    if (i >= MAX_CHILDREN_NUMBER) {
        printf("max children number overflow\n");
    }

    father->children[i] = child;
    child->father = father;
    Morpheme* f= father;
    if (child->lineNumber != -1) {
        while (f != NULL && f->lineNumber == -1) {
            f->lineNumber = child->lineNumber;
            f = f->father;
        }
    }
}

void eliminateEmpty(Morpheme* root) {
    ;
}

void nodeGrowth(Morpheme* father, int n, ...) {
    va_list argp;
    va_start(argp,n);
    for (int i = 0; i < n; i++) {
        addChild(father, va_arg(argp, Morpheme*), i);
    }
}

char* typeToString(Types type) {
    return TYPES_NAME_TABLE[type];
}

void printGrammarTree(Morpheme* root, int depth) {
    //printf("in\n");
    if (root == NULL) {
        return;
    }
    if (root->type == _BLANK) {
        return;
    }
    if (root->lineNumber != -1) {
        for (int k = 0; k < depth; k++) {
            printf("  ");
        }
        if (root->type >= 28) {
            printf("%s (%d)\n", typeToString(root->type), root->lineNumber);
        } else if (root->type <= 27 && root->type >= 1) {
            if (root->type == _ID) {
                printf("%s: %s\n", typeToString(root->type), root->idName);
            } else if (root->type == _INT) {
                printf("%s: %d\n", typeToString(root->type), root->intValue);
            } else if (root->type == _FLOAT) {
                printf("%s: %f\n", typeToString(root->type), root->floatValue);
            } else if (root->type == _TYPE) {
                printf("%s: %s\n", typeToString(root->type), root->idName);
            } else {
                printf("%s\n", typeToString(root->type));
            }
        }
    
        int i = 0;
        while (i < MAX_CHILDREN_NUMBER && root->children[i] != NULL) {
            printGrammarTree(root->children[i], depth + 1);
            i++;
        }
    }
    
    //printf("out %d\n", i);
}