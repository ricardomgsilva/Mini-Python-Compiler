parser grammar PythonParser;

options { tokenVocab=PythonLexer; }


code: (stat | condicional | func | func_call)* EOF;

stat: (expr | query) '\n';

condicional: IF query COLON stat                      # ifSimples
           | IF query COLON stat ELSE COLON stat      # ifElse
           | IF query COLON stat (ELIF query COLON stat)+ ELSE COLON stat # ifElifElse
           ;


func: DEF ID L_PAREN (ID (COMMA ID)*)? R_PAREN COLON stat # definicaoFuncao;


func_call: ID L_PAREN (expr (COMMA expr)*)? R_PAREN # chamadaFuncao;

query: TRUE                            # valoresBooleanos
     | FALSE                           # valoresBooleanos
     | NOT query                       # operacoesBooleanas
     | query (AND | OR) query          # operacoesBooleanasEntreQuerys
     | L_PAREN query R_PAREN           # queryEntreParenteses
     | expr (EQ | NE | GT | LT | GE | LE) expr # relacoesEntreExpressoes
     ;

expr: ID                            # ids
    | INT                           # numeros
    | FLOAT                         # numeros
    | func_call                     # chamadaFuncaoNaExpressao
    | expr (MULT|DIV|PLUS|MINUS) expr # operacoesComExpressoes
    | L_PAREN expr R_PAREN          # expressoesEntreParenteses
    ;