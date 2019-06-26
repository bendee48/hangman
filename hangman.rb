class Player
  attr_accessor :name

  def initialize(name="Player 1")
    @name = name
  end
end

class Display
  def show_gallows
    puts "  ________"
    puts "   |/   |"
    puts ["   |    ", "   |    ", "   |   "]
    puts "   |"
    puts " ==========="
  end
end

class Game
  attr_accessor :display
  
  def initialize
    @display = Display.new
  end

  def game_start
    puts "Welcome to hangman."

  end
end

Display.new.show_gallows