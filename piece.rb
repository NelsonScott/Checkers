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
      return [[1,1], [-1,-1], [1,-1], [-1, 1]]
    elsif :color == :W
      return [[1, -1], [-1, -1]]
    else
      return [[-1, 1], [1, 1]]
    end
  end

  def perform_slide(end_pos)
    raise StandardError.new('cannot move into piece') if !@board[end_pos].nil?
    raise StandardError.new('cannot move there') if !move_diffs.include?(end_pos)

    @board[end_pos] = self
    @board[@pos] = nil

    update_pos(end_pos)
    maybe_promote
  end

  def perform_jump(end_pos)
    possible_jumps = move_diffs.map{|coors| coords.map{|val| val*2}}
    raise 'cannot move there' if !possible_jumps.include?(end_pos)
    raise 'cannot move into piece' if !@board[end_pos].nil?

    @board[end_pos] = self
    midpoint = end_pos.map{|val| val/2}
    #set both the jumped piece pos and our previous pos to nil
    @board[midpoint] = nil
    @board[@pos] = nil

    update_pos(end_pos)
    maybe_promote
  end

  def update_pos(coords)
    @pos = coords
  end

  def maybe_promote
    if @color == :white && @pos[0] == 7
      @isKing = true
    elsif @color == :red && @pos[0] == 0
      @isKing = true
    end
  end
end
