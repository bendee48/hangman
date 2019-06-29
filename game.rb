require './textable'
require 'yaml'

class Game
include Textable
  
  attr_accessor :display, :player, :incorrect_letters,
                :word_to_guess, :correct_letters, :guesses,
                :currently_guessed, :loaded_game

  def initialize
    @display = Display.new
    @incorrect_letters = []
    @correct_letters = []
    @player = Player.new
    @word_to_guess = random_word
    @guesses = 6
    @currently_guessed
    @loaded_game = false
  end
  

  def self.load_game(file)
    file = File.open(file) { |f| f.read }
    game = YAML.load(file)
    game.loaded_game = true
    game.main_game_loop
  end

  def self.launch
    puts "Welcome to Hangman."
    loop do
      puts "Enter (1) to Start a new game or (2) to load your previous game."
      answer = gets.chomp
      if answer == "1"
        Game.new.start; break
      elsif answer == "2"
        Game.load_game('save_game.yaml'); break
      else
        puts "I didn't recognise that."
      end
    end
  end

  def start
    introduction
    main_game_loop
  end

  def save_game
    File.open('save_game.yaml', 'w') { |f| f.puts YAML.dump(self) }
  end

  def main_game_loop
    loop do
      game_opening
      puts "\nEnter a letter"
      answer = gets.chomp.downcase
      validated, error_message = validate_answer(answer)
      break if validated == "quit"
      (puts error_message; redo) unless validated
      answer.size == word_to_guess.size ? (break if check_word(answer)) : check_letter(answer)
      self.currently_guessed = letters_to_display.join
      (win; break) if has_won
      (lose; break) if has_lost
      display.show_gallows
      save_game
    end
  end

  def game_opening
    puts "Welcome back #{player.name}." if loaded_game
    self.loaded_game = false
    display_word
    display_incorrect_letters
  end

  private

  def validate_answer(answer)
    case
    when answer == "quit"
      ["quit"]
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

  def dictionary
    File.open('./5desk.txt') { |file| file.read }.split
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

  def has_won
    currently_guessed == word_to_guess
  end

  def has_lost
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