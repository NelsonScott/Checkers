require_relative 'board'

class Game

  def initialize
    b = Board.new
    white_turn = true

    loop do
      begin
        b.inspect
        white_turn ? (puts "White's turn.") : (puts "Red's turn.")

        puts "Please input starting position: row, col"
        start = get_input

        #change this later to accept multiple positions
        puts "Please input ending position."
        moving = []
        next_move = nil
        until next_move == 'f'
          next_move = get_input
          moving << next_move

          puts "More moves? y/n"
          choice = gets.chomp
          if choice == 'y'
            next_move = get_input
          else
            next_move = 'f'
          end
        end
        b.do_move(start, moving)
      rescue StandardError => e
        puts e.backtrace
        puts e.message
        retry
      end

      #if successful
      white_turn = !white_turn
    end
  end

  def get_input
    gets.chomp.split(",").map(&:to_i)
  end
end

g = Game.new
