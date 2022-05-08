
# DotLexer class
# DotLexer determines the constant type of the token
class DotLexer
  @is_illegal_token = false

  # reads input and determines the text of the token and the type of the token
  def next_token
    # if there was an illegal token
    if @is_illegal_token
      @is_illegal_token = false
      if @token == ";" # if there was a end-of-line semicolon
        return Token.new(@token, Token::SEMI)
      elsif @token == "="
        return Token.new(@token, Token::EQUALS)
      end
      while @token.match(/\W/) do
        puts "illegal char: #{@token}"
        @token = gets(1)
      end
    else  # getting the next token
      @token = gets(1)
    end
    @temp = ""

    # if its the end of the file
    if @token == nil
      return Token.new("", Token::EOF)
    end

    # eating white-space until there is a character
    if @token.match(/\n/) || @token.match(/\s/)
      while @token.match(/\n/) || @token.match(/\s/) do
        @token = gets(1)
      end
    end

    # if the token is a single character
    if @token == "{"
      return Token.new(@token, Token::LCURLY)
    elsif @token == "}"
      return Token.new(@token, Token::RCURLY)
    elsif @token == ";"
      return Token.new(@token, Token::SEMI)
    elsif @token == "["
      return Token.new(@token, Token::LBRACK)
    elsif @token == "]"
      return Token.new(@token, Token::RBRACK)
    elsif @token == "="
      return Token.new(@token, Token::EQUALS)
    elsif @token == ","
      return Token.new(@token, Token::COMMA)
    end

    # the token is a string
    if @token == "\""
      until @token == " " do
        @temp = @temp + @token
        @token = gets(1)
        if @token == "\""
          @temp = @temp + @token
          break
        end
      end
      return Token.new(@temp, Token::STRING)
    end

    # if token is a digit
    if @token.match(/\d/)
      until @token == " " do
        @temp = @temp + @token
        @token = gets(1)
      end
      return Token.new(@temp, Token::INT)
    end

    # if token is a word
    if @token.match(/\w/)
      until @token.match(/\n/) || @token.match(/\s/) do
        if @token.match(/\W/) # there is an illegal token
          @is_illegal_token = true
          break
        end
        @temp = @temp + @token
        @token = gets(1)
      end
      if @temp.downcase == "digraph"
        return Token.new(@temp, Token::DIGRAPH)
      elsif @temp.downcase == "subgraph"
        return Token.new(@temp, Token::SUBGRAPH)
      else
        return Token.new(@temp, Token::ID)
      end
    end

    # if token is a string of non alpha/digit characters
    if @token.match(/\W/)
      until @token.match(/\n/) || @token.match(/\s/) do
        @temp = @temp + @token
        @token = gets(1)
      end
      @token = @temp
    end

    # if token is a multi-character word
    if @token == "->"
      Token.new(@token, Token::ARROW)
    end
  end
end
