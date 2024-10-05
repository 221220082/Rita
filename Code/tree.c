#include "tree.h"
struct Node* creatNode(int w_u,char* w_n,Type t_t,int line,char* val)
{
    struct Node* pointer = (struct Node*)malloc(sizeof(struct Node));
    strcpy(pointer->word_name,w_n);
    pointer->word_unit=w_u;//flex->0 bison->1
    pointer->token_type=t_t;
    pointer->line=line;
    pointer->first_child=NULL;
    pointer->brother=NULL;
    pointer->last_child=NULL;
    switch(t_t)
    {
        case TOKEN_INT:
        {
            sscanf(val,"%d",&pointer->value.val_int);
            break;
        }
        case TOKEN_FLOAT:
        {
            sscanf(val,"%f",&pointer->value.val_float);
            break;
        }
        case TOKEN_FLOAT_E:
        {
            
            break;
        }
        case TOKEN_ID:
        {
            strcpy(pointer->value.val_char,val);
            break;
        }
        case TOKEN_TYPE:
        {
            strcpy(pointer->value.val_char,val);
            break;
        }
        default: break;
    }
    return pointer;   
}
void insert(struct Node* par,struct Node* chi)
{
    if(par->first_child==NULL)
    {
        par->first_child=chi;
        par->last_child=chi;
    }
    else
    {
        par->last_child->brother=chi;
        par->last_child=chi;
    }
}
void treeFree(struct Node* root)
{
    if (root == NULL) {
        return; // 如果节点为空，直接返回
    }
    
    // 递归释放每个子节点
    struct Node* child = root->first_child;
    while (child != NULL) {
        struct Node* next = child->brother; // 保存下一个兄弟节点的指针
        treeFree(child); // 递归释放子节点
        child = next; // 移动到下一个兄弟节点
    }
    
    // 释放当前节点的属性
    
    free(root); // 释放当前节点
}
void printTree(struct Node* root,int tab)
{
    if (root==NULL)
        return;
    for(int i=0;i<tab;i++)
        printf("  ");
    if(root->word_unit==0)
    {
        switch(root->token_type)
        {
            case TOKEN_INT:
            {
                printf("%s: %d\n",root->word_name,root->value.val_int);
                break;
            }
            case TOKEN_FLOAT:
            {
                printf("%s: %f\n",root->word_name,root->value.val_float);
                break;
            }
            case TOKEN_FLOAT_E:
            {
                printf("%s: %f\n",root->word_name,root->value.val_float);
                break;
            }
            case TOKEN_ID:
            {
                printf("%s: %s\n",root->word_name,root->value.val_char);
                break;
            }
            case TOKEN_TYPE:
            {
                printf("%s: %s\n",root->word_name,root->value.val_char);
                break;
            }
            case TOKEN_OTHER:
            {
                printf("%s\n",root->word_name);
                break;
            }
            default:break;
        }
    }
    else
    {
        printf("%s (%d)\n",root->word_name,root->line);

    }
    printTree(root->first_child,tab+1);
    printTree(root->brother,tab);

}