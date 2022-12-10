class Integer
  def colorize(color_code)
    print "\e[#{color_code}m #{self} \e[0m"
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

  def initialize()
    print "Enter your guess of four numbers, from 1 to 6: "
    @code = gets.chomp.gsub(/\s/, "")
    until (@code.length == 4 && @code.scan(/[\D7890]/).empty?)
      print "Wrong input, enter your guess of four numbers, from 1 to 6: "
      @code = gets.chomp.gsub(/\s/, "")
    end
    puts "\n"
    @code = @code.scan(/\d/).map(&:to_i)
  end

  def self.generate_code
    @@answer = Array.new(4) {rand(6) + 1}
  end
  
  def compare()
    @@temp_answer = []
    @@answer.each {|value| @@temp_answer.push(value)}
    look_black_pins()
    look_white_pins()
    @@temp_answer = @@temp_answer - @@temp_answer.join.scan(/\d/).map(&:to_i)
    @@temp_answer.sort.reverse
  end

  def look_black_pins()
    @@temp_answer.each_index { |i|
      if @@temp_answer[i] == @code[i]
        @@temp_answer[i] = "\u25cf" 
        @code[i] = nil
      end
    }
  end

  def look_white_pins()
    @code.each_index { |i| 
      @@temp_answer.each_index { |j|
        if @@temp_answer[j] == @code[i] 
          @@temp_answer[j] = "\u25cb" 
          @code[i] = nil
        end
      }
    }
  end

  def print_colors
    print "Your guess was: "
    @code.each { |value|
      case value
      when 1
        print value.red
      when 2
        print value.green
      when 3
        print value.yellow
      when 4
        print value.orange
      when 5
        print value.purple
      when 6
        print value.cyan
      end
      print " "
    }
    puts "\n\n"
  end

  def print_result(result)
    print "Your guess was this close: "
    result.each{ |v| print "#{v} "}
    puts "\n\n"
  end
end

while(true)
  Game.generate_code
  max_guesses = 10
  total_guesses = 0
  win = false

  while (total_guesses < max_guesses)
    guess = Game.new
    guess.print_colors
    result = guess.compare
    guess.print_result(result)
    if result == Array.new(4, "\u25cf")
      win = true
      break
    end
    total_guesses += 1
  end

  if win
    puts "You win!! Wanna play again? Press 'Y' for yes or any other key for no:"
  else
    puts "You lost... Wanna play again? Press 'Y' for yes or any other key for no:"
  end

  selection = gets.chomp.upcase
  break unless selection == "Y"
end