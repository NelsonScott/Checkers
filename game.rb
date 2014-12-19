require_relative 'board'

class Game

  def initialize
    b = Board.new
    white_turn = true

    loop do
      begin
        b.inspect
        white_turn ? (puts "White's turn.") : (puts "Red's turn.")

        start = get_start
        finish = get_finish

        b.do_move(start, finish)
      rescue StandardError => e
        puts e.backtrace
        puts e.message
        retry
      end

      #if successful
      white_turn = !white_turn
    end
  end

  def get_start
    puts "Please input starting position: row, col"
    get_input
  end

  def get_finish
    puts "Please input next position."
    finish = []
    next_move = nil

    until next_move == 'f'
      next_move = get_input
      finish << next_move

      puts "More moves? y/n"
      choice = gets.chomp
      if choice == 'y'
        puts "Please input next position."
      else
        next_move = 'f'
      end
    end

    finish
  end

  def get_input
    gets.chomp.split(",").map(&:to_i)
  end
end

g = Game.new
