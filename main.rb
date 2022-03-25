
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

def start_game
    start = false

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

def game_on

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


def play
    rules
    wanna_play = start_game
    

    case 
    when !wanna_play then puts "Thanks. BYE!"
        
    when wanna_play then game_on
        
    end

end



play
