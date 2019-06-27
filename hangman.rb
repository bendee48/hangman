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
                :word_to_guess, :correct_letters, :guesses,
                :currently_guessed

  def initialize
    @display = Display.new
    @incorrect_letters = []
    @correct_letters = []
    @file = File.open('./5desk.txt')
    @player = Player.new
    @word_to_guess = "hello"
    @guesses = 6
    @currently_guessed
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
      validated, error_message = validate_answer(answer)
      (puts error_message; redo) unless validated
      if answer.size >= 5
        check_word(answer)
      else
        check_letter(answer)
      end
      self.currently_guessed = letters_to_display.join
      (win; break) if check_win
      (lose; break) if check_loss
      display_incorrect_letters
      p guesses
    end
  end

  def validate_answer(answer)
    case
    when answer.size > 1 && answer.size < 5
      [false, "If you're guessing the whole word it needs to be at least 5 letters. Or else just enter 1 letter."]
    when answer.size > 5 && answer.size != word_to_guess.size
      [false, "Your guess would need to be the same length as the word."]
    when !answer.match?(/\A[a-z]+\z/) 
      [false, "Guess must contain only letters and can't be blank."]
    else
      [true]
    end
  end

  def check_letter(letter)
    puts "checking letter"
    if word_to_guess.include?(letter)
      add_correct_letters(letter)
    else
      add_incorrect_letters(letter)
      self.guesses -= 1
    end
  end

  def check_word(word)
    puts "checking word"
    if word_to_guess == word
      puts "you win"
    else
      puts "wrong bitch"
      self.guesses -= 1
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
    puts "Wrong guessed letters: #{incorrect_letters.join(',')}"
  end

  def letters_to_display
    word_to_guess.chars.map do |letter|
      correct_letters.include?(letter) ? letter : "_"
    end
  end

  def check_win
    currently_guessed == word_to_guess
  end

  def check_loss
    guesses < 1
  end

  def win
    puts "You win"
  end

  def lose
    puts "You lose"
  end

end

p hey = Game.new
hey.game_start
