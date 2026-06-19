parser grammar PythonParser;

options { tokenVocab=PythonLexer; }

// Fase 5: O código agora aceita instruções simples ou blocos condicionais
code: (stat | condicional)* EOF;

// Instrução simples
stat: (expr | query) '\n';

// NOVA REGRA: Estruturas de decisão (if, elif, else)
condicional: IF query COLON stat                      # ifSimples
           | IF query COLON stat ELSE COLON stat      # ifElse
           | IF query COLON stat (ELIF query COLON stat)+ ELSE COLON stat # ifElifElse
           ;

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
    | expr (MULT|DIV|PLUS|MINUS) expr # operacoesComExpressoes
    | L_PAREN expr R_PAREN          # expressoesEntreParenteses
    ;