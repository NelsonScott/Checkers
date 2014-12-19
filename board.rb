# -*- coding: utf-8 -*-
require 'colorize'
require_relative 'piece'

class Board
  attr_reader :game_board
  def initialize(fill_board = true)
    make_starting_grid(fill_board)
  end

  def make_starting_grid(fill_board)
    @game_board = Array.new(8) { Array.new(8) {nil} }
    return unless fill_board

    @game_board.each_with_index do |row, row_i|
      row_i < 3 ? (color = :white) : (color = :red)

      row.each_with_index do |space, col_i|
        if (row_i < 3 || row_i > 4) && dark_piece?(row_i, col_i)
          @game_board[row_i][col_i] = Piece.new([row_i, col_i], self, color, false)
        end
      end
    end
  end

  def dup
    dupped_board = Board.new(false)

    @game_board.each_with_index do |row, row_i|
      row.each_with_index do |pdata, col_i|
        p "Duping: #{pdata}"
        if !pdata.nil?
          p "Found it was not nil"
          dup_p = Piece.new(pdata.pos, dupped_board, pdata.color, pdata.isKing)
          dupped_board[[row_i, col_i]] = dup_p
        end
      end
    end

    dupped_board
  end

  def do_move(start, sequence)
    if check_bounds(start, sequence)
      #only start/end, try a single move
      if sequence.length < 2
        if is_jump?(start, sequence.first)
          self[start].perform_jump(sequence.first)
        else
          self[start].perform_slide(sequence.first)
        end
      #multiple destinations, try a chain of jumps
      else
        puts "Seq longer, perform jumps"
        if self[start].perform_jumps(sequence)
          puts "Jumps success."
        else
          puts "Invalid jump sequence."
        end
      end
    else
      puts "Error, incorrect bounds."
    end

  end

  def is_jump?(first, second)
    row1, col1 = first
    row2, col2 = second
    (row2 - row1).abs > 1
  end

  def check_bounds(start, sequence)
    in_bounds?(start) && !self[start].nil? && sequence.all?{|pos| in_bounds?(pos)}
  end

  def in_bounds?(coords)
    row, col = coords
    (0...8).include?(row) && (0...8).include?(col)
  end

  def [](coords)
    row, col = coords
    @game_board[row][col]
  end

  def []=(coords, pce)
    row, col = coords
    @game_board[row][col] = pce
  end

  def dark_piece?(row_idx, col_idx)
    (row_idx % 2 == 0) && (col_idx % 2 != 0) || (row_idx % 2 != 0) && (col_idx % 2 == 0)
  end

  def inspect
    types = {:pawn => "♙", :king => "♔"}

    print " "
    8.times{|time| print "#{time} "}
    puts ""
    @game_board.each_with_index do |row, row_i|
      print "#{row_i}"
      row.each_with_index do |piece, col_i|
        dark_piece?(row_i, col_i) ? (back = :green) : (back = :black)

        if piece.nil?
          print "  ".colorize(:background => back)
        else
          if piece.isKing
            print " #{types[:king]}".colorize(:color => piece.color, :background => back)
          else
            print " #{types[:pawn]}".colorize(:color => piece.color, :background => back)
          end
        end
      end

      puts ""
    end
  end
end
