parser grammar PythonParser;

// Indica ao Parser para usar os tokens definidos no seu Lexer
options { tokenVocab=PythonLexer; }


code: stat* EOF;


stat: expr '\n';

// Definição de expressões
expr: ID                            # ids
    | INT                           # numeros
    | FLOAT                         # numeros
    | expr (MULT|DIV|PLUS|MINUS) expr # operacoesComExpressoes
    | L_PAREN expr R_PAREN          # expressoesEntreParenteses
    ;