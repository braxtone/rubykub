#!/usr/bin/ruby
# Author: braxtone
# Main gameplay script for Rummikub

require './classes.rb'

#pool = [tile, Tile.new(2, :blue)]
#pool.push(Tile.new(3, :orange))
#puts pool.to_s

# Get number of players
def print_greeting
  puts "Welcome to Rummikub!"
  puts "For more info, please see http://en.wikipedia.org/wiki/Rummikub"
end

def get_players
  # Get number of players in our little game
  puts "How many players are there? (2-4)"
  num_players = gets.chomp[/^[0-9]$/].to_i
  
  while num_players == nil || num_players < 2 || num_players > 4 do
    puts "Please specify a number between 2 and 4."
    num_players = gets.chomp
  end
  
  # Create players based on number of players
  players = [] 

  for i in 1..(num_players) do 
    puts "What is player #{i}'s first name?"
    fname = gets.chomp.capitalize
    puts "What is player #{i}'s last name (or initial)?"
    lname = gets.chomp.capitalize
  
    players.push(Player.new(fname, lname))
    puts "Thanks " + players[-1].to_s + "!"
  end

  puts "All players:"
  players.each { |p| puts p.to_s }

  players
end

def turn(player)
  puts player.to_s + ", it's now your turn."
  puts "What would you like to do?"
  #options
end
print_greeting
players = get_players

puts "Creating pool..."
pool = Pool.new

puts "Getting a rack for each player"
players.each { |p| p.get_rack(pool)}

