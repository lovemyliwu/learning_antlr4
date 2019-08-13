import sys

from gen.calculatorLexer import calculatorLexer, CommonTokenStream
from gen.calculatorVisitor import calculatorVisitor
from gen.calculatorParser import calculatorParser, InputStream


class MyVisitor(calculatorVisitor):
    def __init__(self):
        self.memory = {}

    def visitAssign(self, ctx):
        name = ctx.ID().getText()
        value = self.visit(ctx.expr())
        self.memory[name] = value
        return value

    def visitPrintExpr(self, ctx):
        value = self.visit(ctx.expr())
        print(value)
        return 0

    def visitInt(self, ctx):
        return ctx.INT().getText()

    def visitId(self, ctx):
        name = ctx.ID().getText()
        if name in self.memory:
            return self.memory[name]
        return 0

    def visitMulDiv(self, ctx):
        left = int(self.visit(ctx.expr(0)))
        right = int(self.visit(ctx.expr(1)))
        if ctx.op.type == calculatorParser.MUL:
            return left * right
        return left / right

    def visitAddSub(self, ctx):
        left = int(self.visit(ctx.expr(0)))
        right = int(self.visit(ctx.expr(1)))
        if ctx.op.type == calculatorParser.ADD:
            return left + right
        return left - right

    def visitParens(self, ctx):
        return self.visit(ctx.expr())


if __name__ == '__main__':
    input_stream = InputStream(sys.stdin.readline())

    lexer = calculatorLexer(input_stream)
    token_stream = CommonTokenStream(lexer)
    parser = calculatorParser(token_stream)
    tree = parser.prog()

    #lisp_tree_str = tree.toStringTree(recog=parser)
    #print(lisp_tree_str)

    visitor = MyVisitor()
    print('vistor value:', visitor.visit(tree))