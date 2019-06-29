require './game'
require './player'
require './display'

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



