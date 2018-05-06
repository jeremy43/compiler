#include "tree.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>
#include <assert.h>

/*
void makeNode(char *name, char *text, NodeType type) {
	yylval.typeNode = (Node*)malloc(sizeof(Node));
	yylval.typeNode->lineno = yylineno;
	yylval.typeNode->type = type;
	strcpy(yylval.typeNode->nodeName, name);
	strcpy(yylval.typeNode->text, text);
}
*/
Node* addNode(char *name, int num, int lineno, ...) {
	va_list valist;
	Node *current = (Node*)malloc(sizeof(Node));
	current->type = NT;
	strcpy(current->nodeName, name);
	current->lineno = lineno;
	current->child_num = 0;
	
	va_start(valist, lineno);
	int i;
	Node *temp;
	for (i = 0; i < num; i++ ) {
		temp = va_arg(valist, Node*);
		if (temp != NULL) {
			int index = current->child_num;
			current->child[index] = temp;
			current->child_num++;
		}
		else {
//			printf("\033[31merror:%s:%d\033[0m\n", __func__, __LINE__);
		}
	}
	va_end(valist);
	return current;
}

void printTree(Node *root, int depth) {
	if (root == NULL)
		return ;
	int i;
	char *str;
	for (i = 0; i < depth; i++)
		printf("  ");
 	switch(root->type) {
		case TYPE_INT:
			printf("%s: %d\n", root->nodeName, atoi(root->text));
			break;
		case TYPE_OCT:
			printf("%s: %d\n", root->nodeName, strtol(root->text, &str, 8));
			break;
		case TYPE_HEX:
			printf("%s: %d\n", root->nodeName, strtol(root->text, &str, 16));
			break;
		case TYPE_FLOAT:
			printf("%s: %f\n", root->nodeName, atof(root->text));
			break;
		case TYPE_ID:
			printf("%s: %s\n", root->nodeName, root->text);
			break;
		case TYPE_OTHER:
			if (strcmp(root->nodeName, "TYPE") == 0)
				printf("%s: %s\n", root->nodeName, root->text);
			else
				printf("%s\n", root->nodeName);
			break;
		case NT:
			printf("%s (%d)\n", root->nodeName, root->lineno);
			for (i = 0; i < root->child_num; i++) {
//				printf("root:%s, %dth child(@%p):%d\n", root->nodeName, i, root->child[i], root->child[i] ? root->child[i]->type: -1);
				printTree(root->child[i], depth + 1);
			}
			break;
		default:
			printf("Error NodeType!\n");
	}		
}
