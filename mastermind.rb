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
  def self.create_scenarios()
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
  end 

  attr_reader :code

  def initialize(game_mode = 1, code = [1, 1, 1, 1])
    case game_mode
    when 1
      print "Enter your guess of four numbers, from 1 to 6: "
      @code = gets.chomp.gsub(/\s/, "")
      until (@code.length == 4 && @code.scan(/[\D7890]/).empty?)
        print "Wrong input, enter your guess of four numbers, from 1 to 6: "
        @code = gets.chomp.gsub(/\s/, "")
      end
      puts "\n"
      @code = @code.scan(/\d/).map(&:to_i)
    when 2
      print "Enter the code (4 digits): "
      @@answer = gets.chomp.gsub(/\s/, "")
      until (@@answer.length == 4 && @@answer.scan(/[\D7890]/).empty?)
        print "Wrong input, enter your guess of four numbers, from 1 to 6: "
        @@answer = gets.chomp.gsub(/\s/, "")
      end
      @@answer = @@answer.split("").map(&:to_i)
      puts "\n"
    when 3
      @code = code
    when 4
      @code = @@codes[rand(@@codes.length)]
    end
  end

  def self.generate_code
    @@answer = Array.new(4) {rand(6) + 1}
  end
  
  def compare(test_code = @@answer)
    @@temp_answer = []
    @@temp_code = []
    test_code.each {|value| @@temp_answer.push(value)}
    @code.each {|value| @@temp_code.push(value)}
    look_black_pins()
    look_white_pins()
    @@temp_answer = @@temp_answer - @@temp_answer.join.scan(/\d/).map(&:to_i)
    @@temp_answer.sort.reverse
  end

  def look_black_pins()
    @@temp_answer.each_index { |i|
      if @@temp_answer[i] == @@temp_code[i]
        @@temp_answer[i] = "\u25cf" 
        @@temp_code[i] = nil
      end
    }
  end

  def look_white_pins()
    @@temp_code.each_index { |i| 
      @@temp_answer.each_index { |j|
        if @@temp_answer[j] == @@temp_code[i] 
          @@temp_answer[j] = "\u25cb" 
          @@temp_code[i] = nil
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

  def check_scenarios(result)
    @@codes.each_index { |i|
      @@codes[i] = nil unless self.compare(@@codes[i]) == result
    }
    @@codes.compact!
  end
end

while(true)
  puts "Enter 1 to be code BREAKER or 2 to be code MAKER: "
  game_mode = gets.chomp.to_i
  unless game_mode == 1 || game_mode == 2
    puts "Wrong input, enter 1 to be code BREAKER or 2 to be code MAKER: "
    game_mode = gets.chomp
  end

  max_guesses = 10
  total_guesses = 0
  win = false
  
  case game_mode
  when 1
    Game.generate_code
    while(total_guesses < max_guesses)
      guess = Game.new
      puts "Guess number #{total_guesses + 1}\n"
      guess.print_colors
      result = guess.compare
      guess.print_result(result)
      if result == Array.new(4, "\u25cf")
        win = true
        break
      end
      total_guesses += 1
      puts "You have #{max_guesses - total_guesses} remaining!\n\n\n"
    end
  when 2
    Game.new(game_mode)
    Game.create_scenarios
    game_mode = 3
    while(total_guesses < max_guesses)
      guess = Game.new(game_mode, [1, 2, 3, 3])
      puts "Guess number #{total_guesses + 1}\n"
      game_mode = 4
      guess.print_colors
      result = guess.compare
      guess.print_result(result)
      if result == Array.new(4, "\u25cf")
        win = true
        break
      else
        guess.check_scenarios(result)
      end
      total_guesses += 1
      puts "You have #{max_guesses - total_guesses} guesses remaining!\n\n\n"
      sleep(1)
    end
  end

  if win
    puts "You win!! Wanna play again? Press 'Y' for yes or any other key for no:" if game_mode == 1
    puts "Computer won! Wanna play again? Press 'Y' for yes or any other key for no:" if game_mode != 1
  else
    puts "You lost... Wanna play again? Press 'Y' for yes or any other key for no:" if game_mode == 1
    puts "Computer lost! Wanna play again? Press 'Y' for yes or any other key for no:" if game_mode == 2
  end

  selection = gets.chomp.upcase
  break unless selection == "Y"
end