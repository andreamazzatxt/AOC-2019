input = File.read('2.txt').split(',')



def intCode(input)
    current_index = 0;
    puts(input[current_index])
    while input[current_index] != '99'
        index1 = input[current_index+1].to_i;
        index2 = input[current_index+2].to_i;
        n1 = input[index1].to_i
        n2 = input[index2].to_i
        dest = input[current_index+3].to_i
        case input[current_index].to_i
        when 1
            input[dest] = n1+n2
        when 2
            input[dest] = n1*n2
        else 
            puts(' ERROR : OP not Valid ' + input[current_index].to_s) 
            break
        end
        current_index = current_index +4
    end
    return input[0]
end

def findresults(input)
    noun = 0
    verb = 0
    while true
    new_input = input.clone
    print(new_input)
    new_input[1]=noun;
    new_input[2]=verb;
    puts('noun'+noun.to_s);
    puts(verb)
    result = intCode(new_input)
        if result == 19690720
            break;
        else
            if verb == 99
                if noun ==  99
                    puts('Not Valid combination found!')
                    return
                end
                noun = noun + 1
                verb = 0
            else
                verb = verb+1

            end
        end
    end
    return [noun,verb]

end

#For part one execute only intCode function with the proper input (with the modifications)

print(findresults(input))