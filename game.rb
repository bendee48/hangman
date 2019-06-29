require './textable'

class Game
include Textable
  
  attr_accessor :display, :player, :incorrect_letters,
                :word_to_guess, :correct_letters, :guesses,
                :currently_guessed

  def initialize
    @display = Display.new
    @incorrect_letters = []
    @correct_letters = []
    @dictionary = File.open('./5desk.txt') { |file| file.read }
    @player = Player.new
    @word_to_guess = random_word
    @guesses = 6
    @currently_guessed
  end

  def dictionary
    @dictionary.split
  end

  def start
    introduction
    main_game_loop
  end

  def main_game_loop
    loop do
      display_word
      puts "Enter a letter"
      answer = gets.chomp.downcase
      validated, error_message = validate_answer(answer)
      (puts error_message; redo) unless validated
      if answer.size == word_to_guess.size
        break if check_word(answer)
      else
        check_letter(answer)
      end
      self.currently_guessed = letters_to_display.join
      (win; break) if check_win
      (lose; break) if check_loss
      display.show_gallows
      display_incorrect_letters
    end
  end

  def validate_answer(answer)
    case
    when answer.size > 1 && answer.size != word_to_guess.size
      [false, "If you're guessing the whole word it needs to be the same length as the hidden word. Or else, please just enter 1 letter."]
    when !answer.match?(/\A[a-z]+\z/) 
      [false, "Guess must contain only letters and can't be blank."]
    else
      [true]
    end
  end

  def check_letter(letter)
    if word_to_guess.include?(letter)
      puts "Yes, '#{letter}' is correct!"
      add_correct_letters(letter)
    else
      puts "Sorry, there's no '#{letter}'."
      add_incorrect_letters(letter)
      self.guesses -= 1
      display.add_to_gallows(self.guesses)
    end
  end

  def check_word(word)
    if word_to_guess == word
      win
      true
    else
      puts "Sorry, that's not the word we're looking for."
      self.guesses -= 1
      display.add_to_gallows(self.guesses)
      nil
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
    puts 
    puts (" %s" * word_to_guess.size).chomp % letters_to_display
    puts
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

  def win_lose_word
    word_to_guess.upcase.chars.join(" ")
  end

  def win
    puts "Yaaasss! It was #{win_lose_word}. You win #{player.name}!"
  end

  def lose
    puts "You lose. The word was #{win_lose_word}. Game Over."
    display.show_gallows
  end
  
end