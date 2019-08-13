import sys
from antlr4 import CommonTokenStream
from antlr4 import ParseTreeWalker


from gen.testLexer import testLexer, InputStream
from gen.testParser import testParser
from gen.testListener import testListener


class Printer(testListener):
    def enterWhileComplex(self, ctx:testParser.WhileComplexContext):
        print('in complex while', ctx)


if __name__ == '__main__':
    lexer = testLexer(InputStream(sys.stdin.read()))
    token_stream = CommonTokenStream(lexer)
    token_stream.fill()
    parser = testParser(token_stream)
    tree = parser.statement()
    walker = ParseTreeWalker()
    walker.walk(Printer(), tree)
