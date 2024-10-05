#ifndef _TREE_H_
#define _TREE_H_

#include <stdio.h>
#include "stdarg.h"
#include <stdlib.h>
#include <string.h>
typedef enum
{
    TYPE_NULL,
    TOKEN_INT,
    TOKEN_FLOAT,
    TOKEN_FLOAT_E,
    TOKEN_ID,
    TOKEN_OTHER,
    TOKEN_TYPE
} Type;

struct Node
{
    int word_unit;//flex 0,bison 1
    char word_name[32];//name
    Type token_type;
    int line;
    union {
        int val_int;
        float val_float;
        char val_char[32];
    } value;//cisu
    struct Node* first_child;
    struct Node* brother;
    struct Node* last_child;
};
/* function */
struct Node* creatNode(int w_u,char* w_n,Type t_t,int line,char* val);
void insert(struct Node* par,struct Node* chi);
void treeFree(struct Node* root);
void printTree(struct Node* root,int tab);
#endif