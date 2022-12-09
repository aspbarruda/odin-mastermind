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

  def initialize(code)
    @code = code
  end

  def self.generate_code
    @@answer = Array.new(4) {rand(6) + 1}
  end
  
  def compare()
    @@temp_answer = @@answer
    look_black_pins()
    look_white_pins()
    @@temp_answer = @@temp_answer - @@temp_answer.join.scan(/\d/).map(&:to_i)
    p @@temp_answer.sort.reverse
  end

  def look_black_pins()
    @@temp_answer.each_index { |i|
      if @@temp_answer[i] == @code[i]
        @@temp_answer[i] = "\u2981" 
        @code[i] = nil
      end
    }
  end

  def look_white_pins()
    @code.each_index { |i| 
      @@temp_answer.each_index { |j|
        if @@temp_answer[j] == @code[i] 
          @@temp_answer[j] = "\u25e6" 
          @code[i] = nil
        end
      }
    }
  end
end

while(true)
  Game.generate_code
  print "Enter your guess of four numbers, from 1 to 6: "
  guess = gets.chomp.gsub(/\s/, "")
  until (guess.length == 4 && guess.scan(/[\D7890]/).empty?)
    print "Wrong input, enter your guess of four numbers, from 1 to 6: "
    guess = gets.chomp.gsub(/\s/, "")
  end
  code = Game.new(guess.scan(/\d/).map(&:to_i))
  code.compare
end