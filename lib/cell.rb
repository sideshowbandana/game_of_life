class Cell
  ALIVE = "*"
  DEAD = "."
  CHAOS = "CHAOS"

  def initialize(life = CHAOS)
    if life == CHAOS
      @alive = [true, false].sample
    else
      @alive = life
    end
  end

  def toggle(alive = nil)
    @alive = !@alive
  end

  def alive?
    @alive
  end

  def to_s
    alive? ? ALIVE : DEAD
  end

  def inspect
    self.to_s
  end

  def draw
    self.to_s
  end
end
