require "spec_helper"
describe Board do
  before do
    @size = 4
    @board = Board.new(@size)
  end

  context "#cell_at" do
    it "should return nil when out of bounds" do
      @board.cell_at(-1, 0).should == nil
      @board.cell_at(-1, -1).should == nil
      @board.cell_at(0, -1).should == nil
      @board.cell_at(0, @size).should == nil
      @board.cell_at(@size, 0).should == nil
    end
  end

  context "Any live cell with fewer than two live neighbours" do
    it "dies, as if caused by under-population." do
      cell = @board.cell_at(0, 0)
      cell.toggle(true)
      check_alive([cell], :from => true, :to => false)

      cell.toggle(true)
      cell2 = @board.cell_at(0,1)
      cell2.toggle(true)

      check_alive([cell, cell2], :from => true, :to => false)
    end
  end

  def check_alive(cells, opts = { })
    cells.each do |cell|
      cell.alive?.should == opts[:from]
    end
    @board.tick
    cells.each do |cell|
      cell.alive?.should == opts[:to]
    end
  end

  context "Any live cell with two live neighbours" do
    it "lives on to the next generation." do
      locations = [
                   [0, 0],
                   [0, 1],
                   [1, 0]
                  ]
      locations.each{ |x, y|
        @board.cell_at(x,y).toggle(true)
      }
      check_alive([@board.cell_at(0,0)], :from => true, :to => true)
    end
  end

  context "Any live cell with three live neighbours" do
    it "lives on to the next generation." do
      locations = [
                   [0, 0],
                   [0, 1],
                   [1, 0],
                   [1, 1]
                  ]
      locations.each{ |x, y|
        @board.cell_at(x,y).toggle(true)
      }
      check_alive([@board.cell_at(0,0)], :from => true, :to => true)
    end
  end

  context "#alive_neighbors" do
    it "should not include cell in question" do
      locations = [
                   [0, 0],
                   [0, 1],
                   [1, 0]
                  ]
      locations.each{ |x, y|
        @board.cell_at(x,y).toggle(true)
      }
      @board.alive_neighbors(0, 0).count.should == 2
    end
  end

  context "Any live cell with more than three live neighbours" do
    it "dies, as if by overcrowding." do
      locations = [
                   [0, 0],
                   [0, 1],
                   [1, 0],
                   [1, 1],
                   [2, 1]
                  ]
      locations.each{ |x, y|
        @board.cell_at(x,y).toggle(true)
      }
      check_alive([@board.cell_at(1,1)], :from => true, :to => false)
    end
  end
  context "Any dead cell with exactly three live neighbours" do
    it "becomes a live cell, as if by reproduction." do
      locations = [
                   [0, 0],
                   [0, 1],
                   [1, 0]
                  ]
      locations.each{ |x, y|
        @board.cell_at(x,y).toggle(true)
      }
      check_alive([@board.cell_at(1,1)], :from => false, :to => true)
    end
  end

  context "that prints" do
    it "passes the acceptance tests" do
    end
  end
end
