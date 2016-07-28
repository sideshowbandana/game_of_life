require "curses"
require "pry-byebug"

class Board
  include Curses

  attr_accessor :size

  def initialize
  end

  def self.from_file(path)
    self.new.tap do |board|
      board.from_file(path)
    end
  end

  def self.random(x=10,y = 10)
    self.new.tap do |board|
      board.set_random_board(x,y)
    end
  end

  def from_file(path)
    rows = File.readlines(path)
    @y_size = rows.first.chomp.length
    @size = rows.count
    @board = []
    rows.each do |line|
      @board << line.chars.map{|char| Cell.new(char == Cell::ALIVE) }
    end
  end

  def set_random_board(x, y)
    @size = x
    @y_size = y
    @board = Array.new(x){ Array.new(y) { Cell.new }}
  end

  def activate_cells(cells)
    cells.each{ |x,y|
      cell_at(x,y).toggle(true)
    }
  end

  def each_cell
    @board.each_index do |x|
      @board[x].each_with_index do |cell, y|
        yield cell, x, y
      end
    end
  end

  def tick
    kill = []
    live = []
    each_cell do |cell, x, y|
      alive_count = alive_neighbors(x,y).count
      if cell.alive?
        #rule #1 || rule #3
        if alive_count < 2 || alive_count > 3
          kill << cell
        end
      else
        # rule 4
        if alive_count == 3
          live << cell
        end
      end
    end
    kill.each{ |cell| cell.toggle(false) }
    live.each{ |cell| cell.toggle(true) }
  end

  def cell_at(x, y)
    return nil if (x < 0 || y < 0) || (x >= @size || y >= @y_size)
    begin
      @board[x][y]
    rescue NoMethodError
      binding.pry
      puts "x: #{x}"
      puts "y: #{y}"
      raise
    end
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
    each_cell do |cell, x, y|
      setpos(x, y)
      addstr(cell.draw)
    end
    refresh
  end

  def all_dead?
    @board.flatten.all?{ |cell| !cell.alive?}
  end

  # def appocalypse
  #   if all_dead?
  #     locations = (0..size*10).map{
  #       [rand(size), rand(size)]
  #     }.uniq
  #     activate_cells(locations)
  #   end
  # end

  # def necromancer
  #   cell_at(rand(size), rand(size)).toggle
  # end

  def run(cycles = nil)
    init_screen
    clear
    
    while(lifespan(cycles))
      [:display].each{ |meth|
        send(meth)
        tick
        sleep(0.1)
      }
    end
  end

  def lifespan(num_cycles)
    return true if num_cycles.nil?
    @cycle ||= 0
    (@cycle += 1) < num_cycles
  end
end
