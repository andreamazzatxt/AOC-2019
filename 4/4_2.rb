input = File.read('./4.txt').split('-')
range = input[0].upto(input[1])

def check_valid(pass)
arr = pass.split('')
checkpair = {}
last = 'E'
second_to_last = 'E'
    while true 
        current = arr.shift
        if current == nil
            break
        end

        if current.to_i < last.to_i && last != 'E'
            return false
        elsif last == current
            checkpair[last] = true
        end
        if last == second_to_last && last == current && last != 'E' && second_to_last != 'E'
            checkpair[last] = false
        end

        second_to_last = last 
        last = current 

    end
   
    valid = false 
    checkpair.each{|name,value|
        if value ==  true 
            valid = true
        end
        } 

    return valid == true ? true : false
  

end
valid = 0 

range.each{|number|
    if check_valid(number)
        valid += 1
    end
}
puts('Part Two : ')
puts(valid)



