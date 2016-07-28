require File.expand_path("lib/board.rb")
require File.expand_path("lib/cell.rb")

require 'rubygems'

class GameOfLife
  def run
    Board.from_file("./data/sample_board.txt").run(20)
    Board.from_file("./data/ants.txt").run(50)
    Board.from_file("./data/blinker_ship.txt").run(50)
  end
end

GameOfLife.new.run

