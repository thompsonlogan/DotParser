require_relative 'token'

# Dot Parser class
# A parser for a simplified version of the dot language
# most errors are ignored / not checked for
class DotParser

  # constructor
  def initialize(lexer)
    @lexer = lexer
    @token_list = []
    token = lexer.next_token
    while Token::EOF != token.type do
      @token_list.push(token)
      token = lexer.next_token
    end
    @pointer_index = 0
    @read_pointer = @token_list[@pointer_index]
    @next_pointer = @token_list[@pointer_index+1]
    @is_error = false
  end

  # Moves the read and next pointer to the next token
  def lex
    @pointer_index = @pointer_index + 1
    @read_pointer = @token_list[@pointer_index]
    @next_pointer = @token_list[@pointer_index+1]
  end

  # Function to determine if there is a match for the "graph" nonterminal
  def graph
    if @read_pointer.type == Token::DIGRAPH
      puts "Start recognizing a digraph"
      lex
      if id
        lex
        if @read_pointer.type == Token::LCURLY
          stmt_list
        end
        unless @is_error
          puts "Finish recognizing a digraph"
        end
      end
    else
      puts "this digraph error"
    end
  end

  # Function to determine if there is a match for the "stmt_list" nonterminal
  def stmt_list
    puts "Start recognizing a cluster"
    lex
    while @read_pointer.type != Token::RCURLY
      stmt
      if @read_pointer.type == Token::SEMI
        lex
      elsif @is_error
        return
      end
    end
    puts "Finish recognizing a cluster"
  end

  # Function to determine if there is a match for the "stmt" nonterminal
  def stmt
    if @read_pointer.type == Token::SUBGRAPH
      subgraph
    elsif @next_pointer.type == Token::EQUALS
      puts "Start recognizing a property"
      if id
        lex
        lex
        if id
          lex
        end
        puts "Finish recognizing a property"
      end
    elsif id && @next_pointer.type == Token::ARROW
      edge_stmt
    else
      @is_error = true
      puts "Error: expecting property, edge or subgraph, but found: #{@read_pointer.text}"
    end
  end

  # Function to determine if there is a match for the "edge_stmt" nonterminal
  def edge_stmt
    if id || @read_pointer.type == Token::SUBGRAPH
      puts "Start recognizing an edge statement"
      lex
      if edge
        lex
        edgeRHS
        lex
        if @read_pointer.type == Token::LBRACK
          lex
          attr_list
        elsif id
          @is_error = true
          puts "Error: expecting ; or edge, but found: #{@read_pointer.text}"
          return
        end
      end
      puts "Finish recognizing an edge statement"
    end
  end

  # Function to determine if there is a match for the "attr_list" nonterminal
  def attr_list
    if id
      puts "Start recognizing a property"
      lex
      if @read_pointer.type == Token::EQUALS
        lex
        if id
          lex
          if @read_pointer.type == Token::RBRACK
            lex
            puts "Finish recognizing a property"
          elsif @read_pointer.type == Token::COMMA
            lex
            puts "Finish recognizing a property"
            attr_list
          end
        end
      else
        lex
      end
    end
  end

  # Function to determine if there is a match for the "edgeRHS" nonterminal
  def edgeRHS
    if id || @read_pointer.type == Token::SUBGRAPH
      while @next_pointer.type == Token::ARROW
        if id
          lex
          lex
        end
      end
    end
  end

  # Function to determine if there is a match for the "edge" nonterminal
  def edge
    if @read_pointer.type == Token::ARROW
      true
    end
  end

  # Function to determine if there is a match for the "subgraph" nonterminal
  def subgraph
    if @read_pointer.type == Token::SUBGRAPH
      puts "Start recognizing a subgraph"
      lex
      if id
        lex
        if @read_pointer.type == Token::LCURLY
          stmt_list
          if @read_pointer.type == Token::RCURLY
            lex
          end
        end
      end
      puts "Finish recognizing a subgraph"
    end
  end

  # Function to determine if there is a match for the "id" nonterminal
  def id
    if @read_pointer.type == Token::INT || @read_pointer.type == Token::STRING || @read_pointer.type == Token::ID
      return true
    end
    false
  end
end
