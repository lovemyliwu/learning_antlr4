grammar calculator; // rename to distinguish from Expr.g4

// 内嵌代码 注意python的indent
@parser::members {
def eval(self, left, op, right):
    if self.MUL == op.type:
        return left * right
    elif self.DIV == op.type:
        return left / right
    elif self.ADD == op.type:
        return left + right
    elif self.SUB == op.type:
        return left - right
    elif self.DMUL == op.type:
        return left ** right
@property
def map(self):
    if not hasattr(self, '_map'):
        setattr(self, '_map', {})
    return self._map
@map.setter
def map_setter(self, value):
    if not hasattr(self, '_map'):
        setattr(self, '_map', {})
    self._map = value

# 新增属性
@property
def print_times(self):
    return self._col

# 属性的setter
@print_times.setter
def print_times(self, value):
    self._col = value
}

prog
    returns [result]
    :
    stat+
{$result = 1}
    ;

stat
    returns [result]
    locals [i = 0]
    :
    expr NEWLINE {$result = $expr.value}      # printExpr
    |   ID '=' expr NEWLINE
{
if self.print_times:
    self.print_times = self.print_times - 1
    print(f'第{$i}次出现赋值语句,只提示{self.print_times}次')
self.map[$ID.text] = $expr.value
$result = $expr.value
}
    # assign
    |   NEWLINE                     # blank
    |   CLEAR NEWLINE
{
self.map = {}
}
    # clear
    ;

// 优先级控制
expr
    returns [value]
    :
    <assoc=right> a=expr op='^' b=expr
{$value = self.eval($a.value, $op, $b.value)}
    #DMul
    |   a=expr op=('*'|'/') b=expr
{$value = self.eval($a.value, $op, $b.value)}
    # MulDiv
    |   a=expr op=('+'|'-') b=expr
{$value = self.eval($a.value, $op, $b.value)}
    # AddSub
    |   INT
{$value = $INT.int}
    # int
    |   ID
{$value = self.map.get($ID.text, 0)}
    # id
    |   '(' expr ')'
{$value = $expr.value}
    # parens
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
