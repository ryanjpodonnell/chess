class Piece
  attr_accessor :color, :pos, :board, :unicode

  def initialize(color, pos, board, unicode)
    @color   = color
    @pos     = pos
    @board   = board
    @start   = pos
    @unicode = unicode
  end

  def moves
  end
end

class SlidingPiece < Piece
  VERTICAL   = [[-1, 0], [1, 0]]
  HORIZONTAL = [[0, -1] ,[0, 1]]
  DIAGONAL   = [[-1,-1], [1, 1], [-1, 1], [1, -1]]

  def moves
    possible_moves = []
    self.move_dirs.each do |(row, col)|
      (1..7).each do |multiplier|
        pot_row = (row * multiplier) + self.pos[0]
        pot_col = (col * multiplier) + self.pos[1]
        pot_pos = [pot_row, pot_col]

        if pot_row.between?(0, 7) && pot_col.between?(0,7)
          break if !@board[pot_pos].nil? && @board[pot_pos].color == self.color
          possible_moves << [pot_row, pot_col]
          break if !@board[pot_pos].nil? && @board[pot_pos].color != self.color
        end
      end
    end
    possible_moves
  end
end

class Rook < SlidingPiece
  def move_dirs
    SlidingPiece::VERTICAL + SlidingPiece::HORIZONTAL
  end
end

class Bishop < SlidingPiece
  def move_dirs
    SlidingPiece::DIAGONAL
  end
end

class Queen < SlidingPiece
  def move_dirs
    SlidingPiece::VERTICAL + SlidingPiece::HORIZONTAL + SlidingPiece::DIAGONAL
  end
end

class SteppingPiece < Piece
  def moves
    possible_moves = []
    self.move_dirs.each do |(row, col)|
      pot_row = row + self.pos[0]
      pot_col = col + self.pos[1]
      pot_pos = [pot_row, pot_col]
      
      if pot_row.between?(0, 7) && pot_col.between?(0,7)
        next if !@board[pot_pos].nil? && @board[pot_pos].color == self.color
        possible_moves << [pot_row, pot_col]
      end
    end
    possible_moves
  end
end

class Knight < SteppingPiece
  def move_dirs
    moves =  [
    [-2, -1],
    [-2,  1],
    [-1, -2],
    [-1,  2],
    [ 1, -2],
    [ 1,  2],
    [ 2, -1],
    [ 2,  1]
    ]
  end
end

class King < SteppingPiece
  def move_dirs
    moves =[
    [-1,  0],
    [ 1,  0],
    [ 0, -1],
    [ 0,  1],
    [-1, -1],
    [ 1,  1],
    [-1,  1],
    [ 1, -1]
     ]
   end
end

class Pawn < Piece
  def move_dirs
    if self.color == :white
      moves = [
      [1,  0],
      [1, -1],
      [1,  1]
      ]
    else
      moves = [
      [-1,  0],
      [-1, -1],
      [-1,  1]
      ]
    end
  end
  
  def moves
    possible_moves = []
    self.move_dirs.each do |(row, col)|
      pot_row = row + self.pos[0]
      pot_col = col + self.pos[1]
      pot_pos = [pot_row, pot_col]
      
      if pot_row.between?(0, 7) && pot_col.between?(0,7)
        #if player can take opponents piece
        if !@board[pot_pos].nil? && pot_col != self.pos[1] && @board[pot_pos].color != self.color
          possible_moves << pot_pos
        #if player wants to advance one square
        elsif @board[pot_pos].nil? && pot_col == self.pos[1]
          possible_moves << pot_pos
        end
        #if the pawn is still in the start position
        if self.pos == @start && pot_col == self.pos[1] && color == :white
          if @board[[pot_row + 1, pot_col]].nil?
            possible_moves << [pot_row + 1, pot_col]
          end
        elsif self.pos == @start && pot_col == self.pos[1] && color == :black
          if @board[[pot_row - 1, pot_col]].nil?
            possible_moves << [pot_row - 1, pot_col]
          end
        end
      end
    end
    possible_moves
  end
end