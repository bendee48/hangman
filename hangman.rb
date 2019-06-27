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
  attr_accessor :display, :file, :player, :incorrect_letters,
                :word_to_guess, :correct_letters, :guesses

  def initialize
    @display = Display.new
    @incorrect_letters = []
    @correct_letters = []
    @file = File.open('./5desk.txt')
    @player = Player.new
    @word_to_guess = "hello"
    @guesses = 6
  end

  def dictionary
    file.read.split
  end

  def game_start
    puts "Welcome to hangman."
    loop do
      display_word
      puts "Enter a letter"
      answer = gets.chomp.downcase
      if word_to_guess.include?(answer)
        add_correct_letters(answer)
      else
        add_incorrect_letters(answer)
      end
      display_incorrect_letters
    end
  end

  def add_correct_letters(letter)
    correct_letters << letter if !correct_letters.include?(letter)  
  end

  def add_incorrect_letters(letter)
    incorrect_letters << letter if !incorrect_letters.include?(letter)
  end

  def random_word
    word = dictionary.sample
    until word.size >= 5 && word.size <= 12
      word = dictionary.sample
    end
    word
  end

  def display_word
    puts (" %s" * word_to_guess.size).chomp % letters_to_display
  end

  def display_incorrect_letters
    p incorrect_letters
  end

  def letters_to_display
    word_to_guess.chars.map do |letter|
      correct_letters.include?(letter) ? letter : "_"
    end
  end

end

p hey = Game.new
hey.game_start
