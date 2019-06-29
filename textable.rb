module Textable

  def introduction
    puts "Welcome to Hangman."
    puts "Enter 'i' for instructions or press Return to get started."
    answer = gets.chomp.downcase
    instructions if answer == 'i'
    name_check_loop
    puts "Thanks #{player.name}. Let's begin."
  end

  def name_check_loop
    loop do
      puts "Please enter your name:"
      answer = gets.chomp.downcase 
      (player.name = answer.capitalize; break) if validate_name(answer)
      puts "Use a name solely made up of letters and make it between 3 and 12 characters long."
    end
  end

  def validate_name(name)
    name.match?(/\A[a-z]{3,12}\z/i)
  end

  def instructions
    puts "These are the instructions."
  end

end