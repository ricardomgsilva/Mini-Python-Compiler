parser grammar PythonParser;

// Indica ao Parser para usar os tokens definidos no seu Lexer
options { tokenVocab=PythonLexer; }

// Regra inicial: o código é uma lista de instruções que termina no fim do ficheiro
code: stat* EOF;

// Uma instrução (stat) agora aceita expressões matemáticas OU consultas booleanas
stat: (expr | query) '\n';

// NOVA REGRA: Definição de lógica booleana e comparações 
query: TRUE                            # valoresBooleanos
     | FALSE                           # valoresBooleanos
     | NOT query                       # operacoesBooleanas
     | query (AND | OR) query          # operacoesBooleanasEntreQuerys
     | L_PAREN query R_PAREN           # queryEntreParenteses
     | expr (EQ | NE | GT | LT | GE | LE) expr # relacoesEntreExpressoes
     ;

// Definição de expressões
expr: ID                            # ids
    | INT                           # numeros
    | FLOAT                         # numeros
    | expr (MULT|DIV|PLUS|MINUS) expr # operacoesComExpressoes
    | L_PAREN expr R_PAREN          # expressoesEntreParenteses
    ;