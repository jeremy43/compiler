%{
	#include "syntax.tab.h"
	#include "tree.h"
	int yycolumn = 1;
	extern int isError;
	extern int commentError;
	#define YY_USER_ACTION \
		yylloc.first_line = yylloc.last_line = yylineno; \
		yylloc.first_column = yycolumn; \
		yylloc.last_column = yycolumn + yyleng - 1; \
		yycolumn += yyleng;
	void makeNode(char *name, char *text, NodeType type);
%}
%option	yylineno

DELIM	[ \t\n]
WS		{DELIM}+
LETTER	[a-zA-Z]
DIGIT	[0-9]
DIGITS	{DIGIT}{DIGIT}*
ID		({LETTER}|_)({LETTER}|{DIGIT}|_)*
INT		0|([1-9][0-9]*)
FLOAT	0*({INT}\.[0-9]*)|({INT}?\.[0-9]+)
FLOATE	({FLOAT}|(0*{INT}))[eE][+-]?[0-9]+
TYPE	char|int|float
RELOP	>|<|==|>=|<=|!=
OCT		0[0-7]+
HEX		0[xX][0-9a-fA-F]+
INVALIDNUM	\.?[0-9][0-9a-zA-Z\._]*

%%
"+"	{/*printf("PLUS\n");*/ makeNode("PLUS", yytext, TYPE_OTHER); return PLUS;}
"-"	{/*printf("SUB\n");*/ makeNode("MINUS", yytext, TYPE_OTHER); return MINUS;}
"&&"	{/*printf("AND\n");*/ makeNode("AND", yytext, TYPE_OTHER); return AND;}
"||"	{/*printf("OR\n");*/ makeNode("OR", yytext, TYPE_OTHER); return OR;}
";"	{/*printf("SEMI\n");*/ makeNode("SEMI", yytext, TYPE_OTHER); return SEMI;}
","	{/*printf("COMMA\n");*/ makeNode("COMMA", yytext, TYPE_OTHER); return COMMA;}
"="	{/*printf("ASSIGNOP\n");*/ makeNode("ASSIGNOP", yytext, TYPE_OTHER); return ASSIGNOP;}
"{"	{/*printf("LC\n");*/ makeNode("LC", yytext, TYPE_OTHER); return LC;}
"}"	{/*printf("RC\n");*/ makeNode("RC", yytext, TYPE_OTHER); return RC;}
"["	{/*printf("LB\n");*/ makeNode("LB", yytext, TYPE_OTHER); return LB;}
"]"	{/*printf("RB\n");*/ makeNode("RB", yytext, TYPE_OTHER); return RB;}
"("	{/*printf("LP\n");*/ makeNode("LP", yytext, TYPE_OTHER); return LP;}
")"	{/*printf("RP\n");*/ makeNode("RP", yytext, TYPE_OTHER); return RP;}
"!"	{/*printf("NOT\n");*/ makeNode("NOT", yytext, TYPE_OTHER); return NOT;}
"."	{/*printf("DOT\n");*/ makeNode("DOT", yytext, TYPE_OTHER); return DOT;}
"*"	{/*printf("STAR\n");*/ makeNode("STAR", yytext, TYPE_OTHER); return STAR;}
"/"	{/*printf("DIV\n");*/ makeNode("DIV", yytext, TYPE_OTHER); return DIV;}
"//"	{char c = input(); while (c != '\n') c = input();}
"/*"	{char c = input(); int lineno = yylineno - 1;
		while (1) {
			if (c == EOF) {
				printf("Error type A at line %d: Unmatched expression /*\n", lineno);
				commentError = 1;
				break;
			}
			if (c == '*') {
				c = input();
				if (c == '/')
					break;
			}
			c = input();
		}}
{INT}	{/*printf("INTEGER \'%s\'\n", yytext);*/ makeNode("INT", yytext, TYPE_INT); return INT;}
{OCT}	{/*printf("OCT \'%s\'\n", yytext);*/ makeNode("INT", yytext, TYPE_OCT); return INT;}
{HEX}	{/*printf("HEX \'%s\'\n", yytext);*/ makeNode("INT", yytext, TYPE_HEX); return INT;}
\r		{/**/}
\n		{yycolumn = 1;}
{WS}	{/**/}	
struct	{/*printf("STRUCT\n");*/ makeNode("STRUCT", yytext, TYPE_OTHER); return STRUCT;}
return	{/*printf("RETURN\n");*/ makeNode("RETURN", yytext, TYPE_OTHER); return RETURN;}
if	{/*printf("IF\n");*/ makeNode("IF", yytext, TYPE_OTHER); return IF;}
else	{/*printf("ELSE\n");*/ makeNode("ELSE", yytext, TYPE_OTHER); return ELSE;}
while	{/*printf("WHILE\n");*/ makeNode("WHILE", yytext, TYPE_OTHER); return WHILE;}
{TYPE}	{/*printf("TYPE \'%s\'\n", yytext);*/ makeNode("TYPE", yytext, TYPE_OTHER); return TYPE;}
{ID}	{/*printf("ID \'%s\'\n", yytext);*/ makeNode("ID", yytext, TYPE_ID); return ID;}
{FLOAT}	{/*printf("FLOAT \'%s\'\n", yytext);*/ makeNode("FLOAT", yytext, TYPE_FLOAT); return FLOAT;}
{FLOATE}	{/*printf("FLOAT \'%s\'\n", yytext);*/ makeNode("FLOAT", yytext, TYPE_FLOAT); return FLOAT;}
{RELOP}	{/*printf("RELOP\n");*/ makeNode("RELOP", yytext, TYPE_OTHER); return RELOP;}
{INVALIDNUM}	{ 
				isError = 1;
				printf("Error type A at line %d: Illegal number \'%s\'.\n", yylineno, yytext); makeNode("INT", yytext, TYPE_INT); return INT;}
.	{
	isError = 1;
	printf("Error type A at line %d: Mysterious charaters \'%s\'.\n",
		yylineno, yytext);
	}
%%
void makeNode(char *name, char *text, NodeType type) {
	yylval.typeNode = (Node*)malloc(sizeof(Node));
	yylval.typeNode->lineno = yylineno;
	yylval.typeNode->type = type;
	strcpy(yylval.typeNode->nodeName, name);
	strcpy(yylval.typeNode->text, text);                               
}
