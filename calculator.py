import sys

from antlr4.error.ErrorListener import ErrorListener
from antlr4.error.ErrorStrategy import DefaultErrorStrategy
from antlr4.error.Errors import InputMismatchException

from gen.calculatorLexer import calculatorLexer, CommonTokenStream
from gen.calculatorVisitor import calculatorVisitor
from gen.calculatorParser import calculatorParser, InputStream


class MyVisitor(calculatorVisitor):
    def __init__(self):
        self.memory = {}

    def visitClear(self, ctx):
        print('flush memory!')
        self.memory = {}
        return 0

    def visitAssign(self, ctx):
        name = ctx.ID().getText()
        value = self.visit(ctx.expr())
        self.memory[name] = value
        print(f'keep variable {name}={value}')
        return value

    def visitPrintExpr(self, ctx):
        value = self.visit(ctx.expr())
        print(f'{ctx.expr().getText()}={value}')
        return value

    def visitInt(self, ctx):
        return ctx.INT().getText()

    def visitId(self, ctx):
        name = ctx.ID().getText()
        if name in self.memory:
            return self.memory[name]
        print(f'no variable {name} found, use default value 0')
        return 0

    def visitMulDiv(self, ctx):
        left = int(self.visit(ctx.expr(0)))
        right = int(self.visit(ctx.expr(1)))
        if ctx.op.type == calculatorParser.MUL:
            return left * right
        return left / right

    def visitDMul(self, ctx):
        left = int(self.visit(ctx.expr(0)))
        right = int(self.visit(ctx.expr(1)))
        if ctx.op.type != calculatorParser.DMUL:
            raise Exception('error operator')
        return left**right


    def visitAddSub(self, ctx):
        left = int(self.visit(ctx.expr(0)))
        right = int(self.visit(ctx.expr(1)))
        if ctx.op.type == calculatorParser.ADD:
            return left + right
        return left - right

    def visitParens(self, ctx):
        return self.visit(ctx.expr())


# 收集所有的语法错误信息
# 可以综合判断
class VerboseListener(ErrorListener) :
    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):
        stack = recognizer.getRuleInvocationStack()
        stack.reverse()
        print("rule stack: ", str(stack))
        print(f'line {line} : {column} at {offendingSymbol} : {msg}')


#  直接报语法异常
class ErrorHandler(DefaultErrorStrategy):
    def sync(self, recognizer):
        pass

    def recoverInline(self, recognizer):
        raise InputMismatchException(recognizer)

    def recover(self, recognizer, e):
        raise e

    def reportNoViableAlternative(self, recognizer, e):
        recognizer.notifyErrorListeners("缺少备选条件", e.offendingToken, e)


if __name__ == '__main__':
    input_stream = InputStream(sys.stdin.readline())
    lexer = calculatorLexer(input_stream)
    token_stream = CommonTokenStream(lexer)

    parser = calculatorParser(token_stream)
    parser.print_times = 2
    parser.removeErrorListeners()
    parser.addErrorListener(VerboseListener())
    parser._errHandler = ErrorHandler()

    tree = parser.prog()
    for stat in tree.children:
       print(stat.result)

    visitor = MyVisitor()
    print('vistor value:', visitor.visit(tree))
