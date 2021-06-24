# AnalizadorLexico
Analizador léxico de lenguaje propuesto
```shell
  $flex AnalizadorLexico.l
  $gcc lex.yy.c Tokens.c Literales.c Simbolos.c FuncAux.c -lfl
  $./a.out [archivo de entrada]
```
