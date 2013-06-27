require "curses"

class Board
  include Curses

  attr_accessor :size

  def initialize(x = 3, y = 3)
    @size = x
    @y_size = y
    @board = Array.new(x){ Array.new(y) { Cell.new}}
  end

  def activate_cells(cells)
    cells.each{ |x,y|
      cell_at(x,y).toggle(true)
    }
  end

  def tick
    kill = []
    live = []
    @board.each_index do |x|
      @board[x].each_with_index do |cell, y|
        if cell.alive?
          if alive_neighbors(x,y).count < 2
            # rule #1
            kill << cell
          elsif alive_neighbors(x,y).count > 3
            # rule 3
            kill << cell
          end
        else
          if alive_neighbors(x,y).count == 3
            # rule 4
            live << cell
          end
        end
      end
    end
    kill.each{ |cell| cell.toggle(false) }
    live.each{ |cell| cell.toggle(true) }
  end

  def cell_at(x, y)
    return nil if (x < 0 || y < 0) || (x >= @size || y >= @y_size)
    @board[x][y]
  end

  def alive_neighbors(x, y)
    [0,1,-1].repeated_permutation(2).select do |x_offset, y_offset|
      unless (x_offset == 0 && y_offset == 0)
        cell = cell_at(x + x_offset, y + y_offset)
        !cell.nil? && cell.alive?
      end
    end
  end

  def display
    @board.each_index do |x|
      @board[x].each_with_index do |cell, y|
        setpos(x, y)
        addstr(cell.draw)
      end
    end
    refresh
  end

  def all_dead?
    @board.flatten.all?{ |cell| !cell.alive?}
  end

  def appocalypse
    if all_dead?
      locations = (0..size*10).map{
        [rand(size), rand(size)]
      }.uniq
      activate_cells(locations)
    end
  end

  def necromancer
    cell_at(rand(size), rand(size)).toggle
  end

  def run
    init_screen
    while(true)
      [:display, :appocalypse, :necromancer].each{ |meth|
        send(meth)
        tick
        sleep(0.1)
      }
    end
  end
end
