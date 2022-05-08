require_relative "dot_lexer"
require_relative "dot_parser"

# Uncomment this line for debugging.
# $stdin.reopen("Prog4-s1.in")

lexer = DotLexer.new

parser = DotParser.new(lexer)

parser.graph()



