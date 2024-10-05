#include <stdio.h>
#include "tree.h"
extern int yylineno;
extern struct Node* root;
extern int error_nums;
extern void yyrestart(FILE *file);
extern int yyparse(void);
void yyerror(char *msg);
int main(int argc, char** argv)
{
    if (argc <= 1) return 1;
    FILE* f = fopen(argv[1], "r");
    if(!f)
    {
        perror(argv[1]);
        return 1;
    }
    yyrestart(f);
    yyparse();
    if(error_nums==0)
    {
        printTree(root,0);
    }
    treeFree(root);
    return 0;
}
void yyerror(char *msg) {
    error_nums+=1;
    printf("Error type B at Line ");
}