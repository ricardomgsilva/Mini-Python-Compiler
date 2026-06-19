lexer grammar PythonLexer;

// Palavras-chave
IF: 'if';
ELSE: 'else';
ELIF: 'elif';
FOR: 'for';
WHILE: 'while';
DEF: 'def';
CLASS: 'class';
TRY: 'try';
EXCEPT: 'except';
IMPORT: 'import';
FROM: 'from';
IN: 'in';
AS: 'as';
RETURN: 'return';
PASS: 'pass';
BREAK: 'break';
CONTINUE: 'continue';

// Operadores Booleanos
AND: 'and';
OR: 'or';
NOT: 'not';
TRUE: 'True';
FALSE: 'False';
NONE: 'None';

// Operadores Aritméticos
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
FLOOR_DIV: '//';
MOD: '%';
POW: '**';

// Operadores Relacionais
EQ: '==';
NE: '!=';
GT: '>';
LT: '<';
GE: '>=';
LE: '<=';

// Operadores Booleanos 
BIT_AND: '&';
BIT_OR: '|';
BIT_NOT: '~';
BIT_XOR: '^';

// Símbolos de Atribuição
ASSIGN: '=';
ADD_ASSIGN: '+=';
SUB_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';

// Símbolos e Delimitadores
COLON: ':';
L_PAREN: '(';
R_PAREN: ')';
L_BRACKET: '[';
R_BRACKET: ']';
L_BRACE: '{';
R_BRACE: '}';
COMMA: ',';

INT: DIGITO+;
FLOAT: DIGITO+ '.' DIGITO* | '.' DIGITO+;

STRING: '"' .*? '"' | '\'' .*? '\'';
LISTA: '[' .*? ']';
TUPLA: '(' .*? ')';
SET: '{' .*? '}';
DICTIONARY: '{' .*? ':' .*? '}';

NL: '\n';

// REGRAS OBRIGATÓRIAS DE FINAL DE FICHEIRO
ID: [a-zA-Z_] [a-zA-Z0-9_]*;

fragment LETRA: [a-zA-Z];

fragment DIGITO: [0-9];

WS: [ \t]+ -> skip;