class Piece
  attr_reader :board, :isKing, :color, :pos
  def initialize(pos, board, color, isKing = false)
    @pos = pos
    @board = board
    @color = color
    @isKing = isKing
  end

  def move_diffs
    if isKing
      return [[1,-1],[1, 1], [-1, -1], [-1, 1]]
    elsif @color == :white
      return [[1, -1], [1, 1]]
    else
      return [[-1, -1], [-1, 1]]
    end
  end

  def perform_slide(end_pos)
    raise StandardError.new('cannot move into piece') if !@board[end_pos].nil?
    # possbile are those we can get it using our differences from our start
    possible_moves = move_diffs.map do |diff|
      delta_row, delta_col = diff
      p [@pos[0] + delta_row, @pos[1] + delta_col]
      [@pos[0] + delta_row, @pos[1] + delta_col]
    end
    raise StandardError.new('cannot move that way') if !possible_moves.include?(end_pos)

    @board[end_pos] = self
    @board[@pos] = nil

    update_pos(end_pos)
    maybe_promote
  end

  def perform_jumps(seq)
    puts "In piece,performing jumps"
    begin
      dupped_board = duplicate_board
      puts "Correctly dupped board"
      valid_jumps?(dupped_board, seq)
    rescue StandardError => e
      puts "invalid jumps sequence"
      puts e.backtrace
      puts e.message
      return false
    end

    seq.each do |pos|
      self.perform_jump(pos)
    end
    
    return true
  end

  def valid_jumps?(dupped_board, seq)
    dupe_piece = dupped_board[@pos]

    seq.each do |pos|
      dupe_piece.perform_jump(pos)
    end
  end

  def perform_jump(end_pos)
    jumped_piece = []
    possible_jumps = move_diffs.map do |diff|
      mid_row, mid_col = diff
      delta_row = 2*mid_row
      delta_col = 2*mid_col

      jumpee = [@pos[0] + delta_row, @pos[1] + delta_col]
      if jumpee == end_pos
        jumped_piece = [@pos[0] + mid_row, @pos[1] + mid_col]
      end

      jumpee
    end

    raise StandardError.new('cannot move there') if !possible_jumps.include?(end_pos)
    raise StandardError.new('cannot move into piece') if !@board[end_pos].nil?
    if @board[jumped_piece].color == @color
      raise StandardError.new('cannot jump friendly piece')
    end

    @board[end_pos] = self
    @board[jumped_piece] = nil
    @board[@pos] = nil

    update_pos(end_pos)
    maybe_promote
  end

  def update_pos(coords)
    @pos = coords
  end

  def duplicate_board
    puts "called duplicate"
    @board.dup
  end

  def maybe_promote
    if @color == :white && @pos[0] == 7
      @isKing = true
    elsif @color == :red && @pos[0] == 0
      @isKing = true
    end
  end

  def inspect
    "Pos: #{@pos} Col: #{@color}"
  end

  def to_s
    "Pos: #{@pos} Col: #{@color}"
  end
end
