#ifndef TREE_H
#define TREE_H

#include <stdio.h>
#include <stdlib.h>
#define MAX_NUM_OF_CHILD 16

typedef enum {
	TYPE_INT,
	TYPE_OCT,
	TYPE_HEX,
	TYPE_FLOAT,
	TYPE_ID,
	TYPE_OTHER,
	NT
}NodeType;

typedef struct TreeNode {
	NodeType type;
	char nodeName[32];
	char text[32];
	int lineno;
	int child_num;
	struct TreeNode *child[MAX_NUM_OF_CHILD];
} Node;

Node* addNode(char *name, int num, int lineno, ...);
void printTree(Node *root, int depth);

#endif
