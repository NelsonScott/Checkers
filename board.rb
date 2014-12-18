# -*- coding: utf-8 -*-
require 'colorize'
require_relative 'piece'

class Board
  attr_reader :game_board
  def initialize(size = 8)
    @game_board = Array.new(size) { Array.new(size) {nil} }
    row = 0

    @game_board.each_with_index do |row, row_i|
      row_i < 3 ? (color = :white) : (color = :red)

      row.each_with_index do |space, col_i|
        if (row_i < 3 || row_i > 4) && dark?(row_i, col_i)
            @game_board[row_i][col_i] = Piece.new([row_i, col_i], self, color, false)
        end
      end
    end
  end

  def do_move(start, sequence)
    p "Start: #{start}"
    p "Sequence: #{sequence}"
    if in_bounds?(start) && !self[start].nil? && sequence.all?{|pos| in_bounds?(pos)}
      if sequence.length < 2
        p sequence.first
        self[start].perform_slide(sequence.first)
      end
    else
      puts "Error, out of bounds"
    end
  end

  def in_bounds?(coords)
    row, col = coords
    (0...8).include?(row) && (0...8).include?(col)
  end

  def [](coords)
    row, col = coords
    @game_board[row][col]
  end

  def []=(coords, p)
    row, col = coords
    @game_board[row][col] = p
  end

  def dark?(row_idx, col_idx)
    (row_idx % 2 == 0) && (col_idx % 2 != 0) || (row_idx % 2 != 0) && (col_idx % 2 == 0)
  end

  def inspect
    types = {:pawn => "♙", :king => "♔"}

    @game_board.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|
        dark?(row_i, col_i) ? (back = :green) : (back = :black)

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
