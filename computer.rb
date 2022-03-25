COMBINATIONS = NUMBERS.repeated_permutation(4).to_a

code =  get_new_code
first_guess = ['1', '1', '2', '2']



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

winner = false
next_guess = []

for i in 1..12
    if i == 1
        guess = first_guess
    else
        guess = next_guess
    end


    feedback = get_feedback(code, guess)
    draw_feedback(feedback, guess)

    if feedback == WIN
        puts "You win"
        winner = true
        break
    end

    exact_matches = num_of_exact_matches_in_feedback(feedback)
    new_array = approx_match_filter(guess, feedback.length)

    if exact_matches > 0
        new_array.select! { |array| exact_match_filter(array, guess, exact_matches) == true}
    end

    new_array.select! { |array| get_feedback(code, array).length > feedback.length && num_of_exact_matches_in_feedback(get_feedback(code, array)) > exact_matches}
    
    
    next_guess = new_array[0]
    
    sleep(1)
end

p code

#puts filter.length
#evenBetter = filter.select { |array| exact_match_filter(array, guess, 1) == true}
#puts evenBetter.length






