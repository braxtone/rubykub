#!/usr/bin/ruby
# Author: braxtone
# A file to store all the classes required by the Rummikub gameplay

require 'colorize'

$valid_colors = [ :black, :blue, :red, :yellow ]
$valid_numbers = (1..13).to_a

class Tile
  def initialize(number, color)
    @number = number if $valid_numbers.include? number
    @color = color if $valid_colors.include? color
  end

  def number
    @number
  end

  def color
    @color
  end

  def ==(tile)
    self.color == tile.color && self.number == tile.number
  end

  def to_s
    @number.to_s.colorize(:background => @color)
  end
end

class Joker < Tile
  attr_accessor :number, :color

  def initialize
    @number = nil
    @color = nil
  end
  
  def use(number, color)
    @number = number
    @color = color
  end

  def is_set? 
    !@number.nil? && !@color.nil?
  end

  def to_s
    if is_set?
      @number.to_s.black.on_white  
    else
      "J".black.on_white
    end
  end 
end

class Set
  def add(*tile)
    tile.each { |t| @tiles.push(t) }
  end

  def initialize(*new_tiles)
    @tiles = []
    new_tiles.each { |t| add(t) }
  end
end

class Group < Set
  def get_colors
    @tiles.map { |t| t.color }
  end

  def valid_tiles
    ($valid_colors - get_colors).map { |c| Tile.new(@tiles[0].number, c) }
  end
end

class Run < Set
  def color
    @tiles[0].color
  end

  def first_num
    @tiles[0].number
  end

  def last_num
    @tiles[-1].number
  end

  def valid_tiles
    [Tile.new(self.first_num - 1, self.color), Tile.new(self.last_num + 1, self.color)].select { |t| !t.number.nil? }
  end
end

class Pool
  def initialize
    @tiles = []
    # Create all the tiles using the valid tile
    # numbers and colors arrays. 2 of each
    2.times do
      $valid_numbers.each do |n|
        $valid_colors.each do |c|
          @tiles.push(Tile.new(n, c))
        end
      end
      @tiles.push(Joker.new)
    end
    
    3.times { @tiles.shuffle! }
  end

  def size
    @tiles.length
  end

  def to_s
    @tiles.each { |t| print t.to_s }
  end

  def get_tile(n=1)
    @tiles.pop(n)
  end
end

class Rack
  def initialize(pool)
    @tiles = []
    14.times { @tiles.push(pool.get_tile[0]) }
    self.sort
  end

  def sort 
    @tiles.sort! { |f, s| [f.color, f.number] <=> [s.color, s.number] }
  end

  def get_points
    point_counter = 0
    @tiles.each { |t| t.number += point_counter }
    point_counter
  end

  def get_set_points
  end

  def to_s
    ret = ""
    @tiles.each { |t| ret << t.to_s + " " }
  end
end

class Table
  def initialize
    @sets = []
  end

  def add_set(set)
    @sets.push(set) if set.class == Set
  end 
end

class Player
  attr_accessor :fname, :lname, :rack

  def initialize(fname, lname)
    @fname = fname.capitalize
    @lname = lname.capitalize
  end

  def get_rack(pool)
    @rack = Rack.new(pool)
  end

  def to_s
    lname + ", " + fname
  end
end
