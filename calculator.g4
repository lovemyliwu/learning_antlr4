grammar calculator; // rename to distinguish from Expr.g4

// 内嵌代码 注意python的indent
@parser::members {
# 新增属性
@property
def print_times(self):
    return self._col

# 属性的setter
@print_times.setter
def print_times(self, value):
    self._col = value
}

prog:   stat+ ;

stat
    locals [i = 0]
    :   expr NEWLINE                # printExpr
    |   ID '=' expr NEWLINE
{
if self.print_times:
    self.print_times = self.print_times - 1
    print(f'第{$i}次出现赋值语句,只提示{self.print_times}次')
}
    # assign
    |   NEWLINE                     # blank
    |   CLEAR NEWLINE               # clear
    ;

// 优先级控制
expr:   <assoc=right> expr op='^' expr  #DMul
    |   expr op=('*'|'/') expr      # MulDiv
    |   expr op=('+'|'-') expr      # AddSub
    |   INT                         # int
    |   ID                          # id
    |   '(' expr ')'                # parens
    ;

CLEAR : '###'  ;
DMUL:   '^';
MUL :   '*' ; // assigns token name to '*' used above in grammar
DIV :   '/' ;
ADD :   '+' ;
SUB :   '-' ;
ID  :   [a-zA-Z]+ ;      // match identifiers
INT :   [0-9]+ ;         // match integers
NEWLINE: ';' | '\r'? '\n' ;     // return newlines to parser (is end-statement signal)
WS  :   [ \t]+ -> skip ; // toss out whitespace
