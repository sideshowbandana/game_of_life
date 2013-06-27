class Cell
  def initialize
    @alive = false
  end
  def toggle(alive = nil)
    alive.nil? ? @alive = !@alive : @alive = alive
  end
  def alive?
    @alive
  end
  def draw
    alive? ? "0" : "."
  end
end
