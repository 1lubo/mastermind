
# COLORS

RED = "\e[1;31m"        # Red
GREEN = "\e[1;32m"      # Green
YELLOW ="\e[1;33m"     # Yellow
BLUE = "\e[1;34m"       # Blue
PURPLE = "\e[1;35m"     # Purple
WHITE = "\e[1;37m"      # White
CLOSE = "\e[0m"         # End color mode

ColorCodes = {"1" => "#{RED}| 1 |#{CLOSE}", "2" => "#{GREEN}| 2 |#{CLOSE}", "3" => "#{YELLOW}| 3 |#{CLOSE}", "4" => "#{BLUE}| 4 |#{CLOSE}",
"5" => "#{PURPLE}| 5 |#{CLOSE}", "6" => "#{WHITE}| 6 |#{CLOSE}"}

# SYMBOLS

ApproxMatch = "\u{25CE} "
ExactMatch = "\u{23FA} "

# Numbers

NUMBERS = ['1', '2', '3', '4', '5', '6']

WIN = ["\u{23FA} ", "\u{23FA} ", "\u{23FA} ", "\u{23FA} "]

FIRSTGUESS = ['1', '1', '2', '2']
COMBINATIONS = NUMBERS.repeated_permutation(4).to_a

def rules
    puts '#' * 21
    puts
    puts "This is the game Mastermind"
    puts "Your task is to crack the secret 4-digit code in 12 or less turns"
    puts "You will receive feedback on each of your guesses"
    puts "#{ExactMatch} - to indicate that you guessed a right number in the right position"
    puts "#{ApproxMatch} - to indicate that you guessed a right number but it is in a wrong position"
    puts
    puts '#' * 21
    puts
end

def get_new_code
    return NUMBERS.sample(4)
end

def get_feedback(code, guess) 

    feedback = []
    temporary_1 = []

    code.each_with_index do |number, ind| 
        
        if number == guess[ind]
            feedback.push(ExactMatch) # push exact_match symbol for all exact guesses
        else
            temporary_1.push(code[ind]) # push numbers which do not match to remporary array
        end

    end

    temporary_2 = guess & temporary_1 # create another temporary array which is an intersection of the guessed numbers and the numbers which were not exact matches

    temporary_2.each { |num| feedback.push(ApproxMatch)} # each number in this array means it's an approximate match. Approximate match symbol is pushed to feedback

    return feedback

end

def draw_feedback(feedback, guess)

    message = []
    guess.each { |num| message.push(ColorCodes.fetch(num))} # write guessed numbers 

    
    puts "\n Your guess \t \t Feedback \n #{message.join()}    #{feedback.join(' ')}"
    
end

def get_new_cipher
    new_cipher = []
    puts " \n Please enter your cipher. The computer will then try to guess it. Four numbers between 1 and 6 (Press Enter after each number)"
    while new_cipher.length < 4
        new_cipher.push(get_number)
    end
    return new_cipher
end

def get_number
    good_number = false

    while !good_number
        number = gets.chomp
        if number.to_i < 1 || number.to_i > 6            
            puts "\n Please enter a number between 1 and 6"
            next 
        end
        good_number = number    
    end
    
    return good_number
end

def get_next_guess
    new_guess = []
    puts " \n Please enter your guess. Four numbers between 1 and 6 (Press Enter after each number)"
    while new_guess.length < 4
        new_guess.push(get_number)
    end
    return new_guess
end

def break_or_make
    input = ''
    until input == '1' || input == '2'
      
      puts '  Are you a code breaker or a code maker?'
      puts "  Enter '1' to break the code or '2' to make the code:"
      input = gets.chomp
    end
    return input
end

def start_game
    start = false

    puts "\n  Welcome to Mastermind!"
    puts '  ---'
    puts "Would you like to play Y / N"

    while !start
        answer = gets.chomp
        
        if answer.downcase == 'y' || answer.downcase == 'yes'
            start = true

        elsif answer.downcase == 'n' || answer.downcase == 'no'
            break
        else
            puts "Plese answer Y/N or Yes/No"
        end
    end
    
    return start
end

def game_on_player
    rules
    code = get_new_code

    for i in 1..12 do
        guess = get_next_guess
        feedback = get_feedback(code, guess)
        draw_feedback(feedback, guess)
        if feedback == WIN
            puts "YOU WIN"
            return
        end
        if i > 8
            puts "You have #{12 - i} turns left!"
        end
    end

    puts "You lose. Better luck next time"
end

def exact_match_filter(code, guess, num_of_matches)
    result = code.zip(guess).map {|a, b| b if a == b}
    result.compact!
    return result.length >= num_of_matches
end

def approx_match_filter(guess, feedback_length)
    filtered_combinations = COMBINATIONS.select { |array| array.intersection(guess).length == feedback_length}
    return filtered_combinations
end

def num_of_exact_matches_in_feedback(feedback)
    return feedback.count { |s| s == ExactMatch}
end

def game_on_computer(cipher)
    winner = false
    next_guess = []

    for i in 1..12
        if i == 1
            guess = FIRSTGUESS
        else
            guess = next_guess
        end


        feedback = get_feedback(cipher, guess)
        draw_feedback(feedback, guess)

        if feedback == WIN
            puts "The computer guessed your code #{cipher}"
            winner = true
            break
        end

        exact_matches = num_of_exact_matches_in_feedback(feedback)
        new_array = approx_match_filter(guess, feedback.length)

        if exact_matches > 0
            new_array.select! { |array| exact_match_filter(array, guess, exact_matches) == true}
        end

        new_array.select! { |array| get_feedback(cipher, array).length > feedback.length && num_of_exact_matches_in_feedback(get_feedback(cipher, array)) > exact_matches}
        
        
        next_guess = new_array[0]
        
        sleep(1)
    end
end

def play
    
    wanna_play = start_game
    

    case 
    when !wanna_play then puts "Thanks. BYE!"
        
    when wanna_play then bOm = break_or_make
        
    end

    case
    when bOm == '1' then game_on_player
    when bOm == '2' then game_on_computer(get_new_cipher)
    end

end



play
