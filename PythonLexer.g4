lexer grammar PythonLexer;

@lexer::header {
import java.util.*;
}

@lexer::members {
    private java.util.LinkedList<Integer> indentStack = new java.util.LinkedList<>();
    private java.util.LinkedList<Token> pendingTokens = new java.util.LinkedList<>();
    private boolean indentStackInit = false;

    private Token makeToken(int type, String text) {
        int start = getCharIndex() - 1;
        int stop = getCharIndex() - 1;
        Token t = _factory.create(
            new org.antlr.v4.runtime.misc.Pair<TokenSource, CharStream>(this, _input),
            type, text, Token.DEFAULT_CHANNEL,
            start, stop,
            getLine(), getCharPositionInLine()
        );
        return t;
    }

    @Override
    public Token nextToken() {
        if (!indentStackInit) {
            indentStack.push(0);
            indentStackInit = true;
        }
        if (!pendingTokens.isEmpty()) {
            return pendingTokens.poll();
        }
        Token t = super.nextToken();
        if (!pendingTokens.isEmpty()) {
            return pendingTokens.poll();
        }
        if (t.getType() == Token.EOF) {
            if (indentStack.peek() > 0) {
                while (indentStack.peek() > 0) {
                    indentStack.pop();
                    pendingTokens.add(makeToken(DEDENT, "<DEDENT>"));
                }
                pendingTokens.add(t); // o EOF fica para o fim da fila
                return pendingTokens.poll();
            }
        }
        return t;
    }

    private void handleNewline(String wsAfterNewline) {
        if (!indentStackInit) {
            indentStack.push(0);
            indentStackInit = true;
        }
        int indent = wsAfterNewline.length();

        // O NL e sempre emitido (visivel para o parser).
        pendingTokens.add(makeToken(NL, "\n"));

        int prevIndent = indentStack.peek();
        if (indent > prevIndent) {
            indentStack.push(indent);
            pendingTokens.add(makeToken(INDENT, "<INDENT>"));
        } else if (indent < prevIndent) {
            while (indent < indentStack.peek()) {
                indentStack.pop();
                pendingTokens.add(makeToken(DEDENT, "<DEDENT>"));
            }
        }
        // se indent == prevIndent, nao emite INDENT nem DEDENT, so o NL.
    }
}

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

AND: 'and';
OR: 'or';
NOT: 'not';
TRUE: 'True';
FALSE: 'False';
NONE: 'None';

FLOOR_DIV: '//';
POW: '**';
PLUS: '+';
MINUS: '-';
MULT: '*';
DIV: '/';
MOD: '%';

EQ: '==';
NE: '!=';
GE: '>=';
LE: '<=';
GT: '>';
LT: '<';

BIT_AND: '&';
BIT_OR: '|';
BIT_NOT: '~';
BIT_XOR: '^';

ADD_ASSIGN: '+=';
SUB_ASSIGN: '-=';
MULT_ASSIGN: '*=';
DIV_ASSIGN: '/=';
ASSIGN: '=';
ARROW: '->';

COLON: ':';
L_PAREN: '(';
R_PAREN: ')';
L_BRACKET: '[';
R_BRACKET: ']';
L_BRACE: '{';
R_BRACE: '}';
COMMA: ',';

COMPLEX: (DIGITO+ ('.' DIGITO*)? | '.' DIGITO+) [jJ];
INT: DIGITO+;
FLOAT: DIGITO+ '.' DIGITO* | '.' DIGITO+;

STRING_MULTILINE: '"""' .*? '"""' | '\'\'\'' .*? '\'\'\'';
STRING: '"' .*? '"' | '\'' .*? '\'';

fragment ESPACO: [ \t]*;
fragment LITERAL_SIMPLES: (DIGITO+ ('.' DIGITO*)? | '"' .*? '"' | '\'' .*? '\'' | 'True' | 'False' | 'None');
fragment PAR_CHAVE_VALOR: LITERAL_SIMPLES ESPACO ':' ESPACO LITERAL_SIMPLES;

LISTA: '[' ESPACO LITERAL_SIMPLES (ESPACO ',' ESPACO LITERAL_SIMPLES)* ESPACO ']';
TUPLA: '(' ESPACO LITERAL_SIMPLES ESPACO ',' ESPACO LITERAL_SIMPLES (ESPACO ',' ESPACO LITERAL_SIMPLES)* ESPACO ')';
SET: '{' ESPACO LITERAL_SIMPLES ESPACO ',' ESPACO LITERAL_SIMPLES (ESPACO ',' ESPACO LITERAL_SIMPLES)* ESPACO '}';
DICTIONARY: '{' ESPACO PAR_CHAVE_VALOR (ESPACO ',' ESPACO PAR_CHAVE_VALOR)* ESPACO '}';

NL: '\n' [ \t]* {
        String txt = getText();
        String ws = txt.substring(1);
        handleNewline(ws);
        setChannel(HIDDEN);
    };

INDENT: 'INDENT_NUNCA_USADO_DIRETAMENTE' ;
DEDENT: 'DEDENT_NUNCA_USADO_DIRETAMENTE' ;

ID: [a-zA-Z_] [a-zA-Z0-9_]*;

fragment LETRA: [a-zA-Z];

fragment DIGITO: [0-9];

WS: [ \t\r]+ -> skip;
