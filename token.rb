# frozen_string_literal: true

# Token class
# A token has a type and a text. The type of the token can be one of the
# predefined constants for the token types. The text of a token
# is a combination of characters.
class Token
  # constants for defining tokens
  EOF = 0 # end of file constant
  ID = 1 # identifier constant
  INT = 2 # integer constant
  STRING = 3 # string constant
  LCURLY = 4 # { constant
  RCURLY = 5 # } constant
  SEMI = 6 # ; constant
  LBRACK = 7 # [ constant
  RBRACK = 8 # ] constant
  ARROW = 9 # -> constant
  EQUALS = 10 # = constant
  DIGRAPH = 11 # digraph word constant
  SUBGRAPH = 12 # subgraph word constant
  COMMA = 13 # , constant
  WS = 14 # whitespace constant
  INVALID = 15 # invalid constant

  # constructor
  def initialize(text, type)
    @text = text
    @type = type
  end

  # Returns the type of the token
  def type
    return @type
  end

  # Returns the text of the token
  def text
    return @text
  end

  # Returns a string representation of the token
  def to_s
    "[#{@text}:#{@type}]"
  end
end
