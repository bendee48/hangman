module Textable

  def introduction
    puts "Enter 'i' for instructions or press Return to get started."
    answer = gets.chomp.downcase
    instructions if answer == 'i'
    name_check_loop
    puts "Thanks #{player.name}. Let's begin."
  end

  def name_check_loop
    loop do
      puts "\nPlease enter your name:"
      answer = gets.chomp.downcase 
      (player.name = answer.capitalize; break) if validate_name(answer)
      puts "Use a name solely made up of letters and make it between 3 and 12 characters long."
    end
  end

  def validate_name(name)
    name.match?(/\A[a-z]{3,12}\z/i)
  end

  def instructions
    puts "Guess the hidden word before another innocent stickman is condemned."; sleep 3
    puts "..."; sleep 2
    puts "A row of dashes represents each letter of a hidden word."; sleep 4
    puts "The word will be between 5 and 12 characters long."; sleep 3
    puts "Enter 1 letter to make a guess. If that letter is present in the hidden word,"; sleep 3
    puts  "those letters will be revealed."; sleep 3
    puts "Otherwise, you'll lose a life and a part of the stickman will be drawn."; sleep 3
    puts "You can also guess the whole word at any time. But an incorrect guess will lose you a life."; sleep 5
    puts "Guess the word before the stickman is fully drawn!"; sleep 3
    puts "The game is auto-saved after every turn."; sleep 3
    puts "You can enter 'quit' at any time to leave the game."; sleep 3
    puts "Choose the 'load game' option at the beginning to carry on a previous game."; sleep 3
    puts "Have fun."
  end

end