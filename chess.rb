require './chessboard.rb'
require './chesspieces.rb'
require 'io/console'
require 'colorize'

class Game
  attr_accessor :board

  def initialize
    @board = Board.new
    @cursor = [0,0]
  end

  def play

    until false
      @piece_to_move = nil
      @tile_to = nil

      system("clear")
      self.display_board

      move = STDIN.getch
      toggle(move)
      next if !@piece_to_move

      while true
        system("clear")
        p @piece_to_move.moves
        self.display_board
        move = STDIN.getch
        return if !toggle(move)
        #next if invalid_input?(move)
        break if @tile_to == @cursor
        puts "Invalid Move"
      end

      self.board.grid[@cursor[0]][@cursor[1]] = @piece_to_move
      self.board.grid[@piece_to_move.pos[0]][@piece_to_move.pos[1]] = nil
      @piece_to_move.pos = [@cursor[0], @cursor[1]]
      self.display_board
    end
  end

  def invalid_input?(move)
    return true if !["s", "m", "l", "k", "j", "i", "q"].include?(move) && !@piece_to_move
    return true if !["s", "h" , "l", "k", "j", "i", "q"].include?(move)
    false
  end

  def display_board
    display = []
    @board.grid.each_with_index do |row, r_idx|
      row.each_with_index do |square, c_idx|
        if [r_idx, c_idx] == @cursor
          display << "| ".blink
        elsif !square.nil?
           display << square.unicode + " "
         else
           display << "* "
         end
       end
       display << "\n"
     end
     puts display.join
   end

  def toggle(move)
    #tile = @board.grid[@cursor[0]][@cursor[1]]
    case move
      when "i"
        @cursor[0] -= 1 unless @cursor[0] == 0
      when "j"
        @cursor[1] -= 1 unless @cursor[1] == 0
      when "k"
        @cursor[0] += 1 unless @cursor[0] == 7
      when "l"
        @cursor[1] += 1 unless @cursor[1] == 7
      when "m"
        @piece_to_move = self.board.grid[@cursor[0]][@cursor[1]]
      when "h"
        @tile_to = [@cursor[0], @cursor[1]] if @piece_to_move.moves.include?([@cursor[0], @cursor[1]])
      when "q"
        return false
    end
    true
  end


end

game = Game.new
game.play