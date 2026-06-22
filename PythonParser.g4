parser grammar PythonParser;

options { tokenVocab=PythonLexer; }

code: (stat | condicional | func | func_call | loop_while | loop_for)* EOF;

stat: (atribuicao | return_stat | break_stat | continue_stat | import_stat | query) NL
    | condicional
    | loop_while
    | loop_for
    | func
    | L_BRACE NL? stat* R_BRACE NL?
    | INDENT stat+ DEDENT
    ;

stat_sem_nl: (atribuicao | return_stat | break_stat | continue_stat | import_stat | query) NL?
           | condicional
           | loop_while
           | loop_for
           | func
           | L_BRACE NL? stat* R_BRACE NL?
           | INDENT stat+ DEDENT
           ;

atribuicao: ID ASSIGN expr              # atribuicaoSimples
          | ID ADD_ASSIGN expr           # atribuicaoAdicao
          | ID SUB_ASSIGN expr           # atribuicaoSubtracao
          | ID MULT_ASSIGN expr          # atribuicaoMultiplicacao
          | ID DIV_ASSIGN expr           # atribuicaoDivisao
          ;

return_stat: RETURN expr # returnSimples;

break_stat: BREAK # breakSimples;

continue_stat: CONTINUE # continueSimples;

import_stat: IMPORT ID              # importSimples
           | FROM ID IMPORT ID      # fromImport
           ;

// Estrutura de repetição while
loop_while: WHILE query COLON NL? stat # loopWhile;

// Estrutura de repetição for
loop_for: FOR ID (COMMA ID)* IN expr COLON NL? stat # loopFor;

condicional: IF query COLON NL? stat                                                          # ifSimples
           | IF query COLON NL? stat_sem_nl ELSE COLON NL? stat                               # ifElse
           | IF query COLON NL? stat_sem_nl (ELIF query COLON NL? stat_sem_nl)+ ELSE COLON NL? stat # ifElifElse
           ;

func: DEF ID L_PAREN (parametro (COMMA parametro)*)? R_PAREN (ARROW ID)? COLON NL? stat # definicaoFuncao;

parametro: ID (COLON ID)? (ASSIGN expr)? # parametroSimples;

func_call: ID L_PAREN (expr (COMMA expr)*)? R_PAREN # chamadaFuncao;

// Listas, tuplos e sets com variaveis/expressoes
lista_var: L_BRACKET (expr (COMMA expr)*)? R_BRACKET # listaComExpressoes;
tupla_var: L_PAREN expr COMMA expr (COMMA expr)* R_PAREN  # tuploComExpressoes;
set_var:   L_BRACE expr COMMA expr (COMMA expr)* R_BRACE  # setComExpressoes;
dict_var:  L_BRACE (expr COLON expr (COMMA expr COLON expr)*)? R_BRACE # dicionarioComExpressoes;

query: NOT query                       # operacoesBooleanas
     | BIT_NOT query                   # operacaoBitANaoUnaria
     | query (AND | OR) query          # operacoesBooleanasEntreQuerys
     | query (BIT_AND | BIT_OR | BIT_XOR) query # operacoesBitABitEntreQuerys
     | L_PAREN query R_PAREN           # queryEntreParenteses
     | expr (EQ | NE | GT | LT | GE | LE) expr # relacoesEntreExpressoes
     | expr ((EQ | NE | GT | LT | GE | LE) expr)+ # relacoesEncadeadas
     | expr                            # queryExpressaoSimples
     ;

expr: ID                            # ids
    | INT                           # numeros
    | FLOAT                         # numeros
    | COMPLEX                       # numerosComplexos
    | TRUE                          # valoresBooleanosExpr
    | FALSE                         # valoresBooleanosExpr
    | NONE                          # valoresNoneExpr
    | STRING                        # cadeiasCaracteres
    | STRING_MULTILINE              # cadeiasCaracteresMultilinha
    | LISTA                         # listasLiterais
    | lista_var                     # listasComVariaveis
    | TUPLA                         # tuplosLiterais
    | tupla_var                     # tuplosComVariaveis
    | SET                           # conjuntosLiterais
    | set_var                       # conjuntosComVariaveis
    | DICTIONARY                    # dicionarios
    | dict_var                      # dicionariosComExpressoes
    | func_call                     # chamadaFuncaoNaExpressao
    | expr L_BRACKET expr R_BRACKET                    # indexacao
    | expr L_BRACKET expr? COLON expr? R_BRACKET       # slicing
    | MINUS expr                    # menosUnario
    | expr (MULT|DIV|PLUS|MINUS|POW) expr # operacoesComExpressoes
    | L_PAREN expr R_PAREN          # expressoesEntreParenteses
    ;
