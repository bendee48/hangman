class Player
  attr_accessor :name

  def initialize(name="Player 1")
    @name = name
  end

  def name
    @name.capitalize
  end
end