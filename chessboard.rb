class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    populate_grid
  end

  def populate_grid
    back_row = [[Rook,   "\u2656", "\u265C"], 
                [Knight, "\u2658", "\u265E"], 
                [Bishop, "\u2657", "\u265D"],
                [Queen,  "\u2655", "\u265B"],
                [King,   "\u2654", "\u265A"],
                [Bishop, "\u2657", "\u265D"],
                [Knight, "\u2658", "\u265E"],
                [Rook,   "\u2656", "\u265C"]]
    back_row.each_with_index do |piece, idx|
      self.grid[1][idx] = Pawn.new(:white,     [1, idx], self, "\u2659")
      self.grid[6][idx] = Pawn.new(:black,     [6, idx], self, "\u265F")
      self.grid[0][idx] = piece[0].new(:white, [0, idx], self, piece[1])
      self.grid[7][idx] = piece[0].new(:black, [7, idx], self, piece[2])
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def in_check?(color)
    check = []
    king = nil
    @grid.flatten.each do |square|
      if square.class == King && square.color == color
        king = square.pos
      elsif !square.nil? && square.color != color
        check << square.moves
      end
    end
    return true if check.flatten(1).include?(king)
    false
  end

  def check_mate(color)
    #return true if all color_moves in check?
    #false
  end

end