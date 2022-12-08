class String
  def colorize(color_code)
    puts "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(41)
  end

  def green
    colorize(42)
  end

  def yellow
    colorize(43)
  end

  def orange
    colorize(44)
  end

  def purple
    colorize(45)
  end

  def cyan
    colorize(46)
  end
end

class Game
  @@codes = []
  for i in (1..6)
    for j in (1..6)
      for k in (1..6)
        for l in (1..6)
          @@codes.push([i, j, k, l])
        end
      end
    end
  end

  attr_reader :code

  def initialize(code = Game.generate_code)
    @code = code
  end

  def self.generate_code
    code = Array.new(4) {rand(6) + 1}
  end
end

while(true)
  answer = Game.new
  print "Enter your guess of four numbers, from 1 to 6: "
  guess = gets.chomp.gsub(/\s/, "")
  until (guess.length == 4 && guess.scan(/[\D7890]/).empty?)
    print "Wrong input, enter your guess of four numbers, from 1 to 6: "
    guess = gets.chomp.gsub(/\s/, "")
  end
end