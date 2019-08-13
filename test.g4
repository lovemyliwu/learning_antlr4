grammar test;
//tokens { STRING }

//MA locals [int i=0]: {$i<=3}? A {$i++;} *;

//DOUBLE1 : '"' .*? '"' -> type(STRING);
//SINGLE1 : '\'' .*? '\'' -> type(STRING);
NAME : [a-z]+;
NUMBER : [0-9]+;
HELLO : H E L L O;

CLS : 'class ';
def_cls : CLS NAME '()';
statement : 'while' '(' expr ')' statement # WhileOnly
    | '{' statement* '}' # WhileComplex
    | NAME '()'  # MethodCall
    ;

expr : NAME '>=' NUMBER+;
method : 'def ' # KeywordName
    ;
parameter: HELLO # MA
    | NAME # PostionArg
    | NAME '=' NAME # NamedArg
    | '*' NAME # NonLengthPositionArg
    | '**' NAME # NonLengthNamedArg
//    | DOUBLE1 # Double1
//    | SINGLE1 # Signle1
 ;
def_method :
    method NAME '()' # DefMethodOne
    | method NAME '(' parameters+=parameter (',' parameters+=parameter)* ')' # DefMethodTwo
    ;

root :
    def_method  # DefMethod
    | def_cls   # DefClass
    ;
WS     : [ \r\t\n]+    -> skip ;
fragment A : [aA]; // match either an 'a' or 'A'
fragment B : [bB];
fragment C : [cC];
fragment D : [dD];
fragment E : [eE];
fragment F : [fF];
fragment G : [gG];
fragment H : [hH];
fragment I : [iI];
fragment J : [jJ];
fragment K : [kK];
fragment L : [lL];
fragment M : [mM];
fragment N : [nN];
fragment O : [oO];
fragment P : [pP];
fragment Q : [qQ];
fragment R : [rR];
fragment S : [sS];
fragment T : [tT];
fragment U : [uU];
fragment V : [vV];
fragment W : [wW];
fragment X : [xX];
fragment Y : [yY];
fragment Z : [zZ];