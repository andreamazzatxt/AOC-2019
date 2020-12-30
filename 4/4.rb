input = File.read('./4.txt').split('-')
range = input[0].upto(input[1])

def check_valid(pass)
#check length
if pass.length != 6 
    return false
end
#check adiacents 
#LtoR never decrease
arr = pass.split('')
checks_adiacents = 0
check_ascend = 0
arr.each_with_index{|char,index|
next_char = arr[index+1] ? arr[index+1] : 'E'
if char == next_char
    checks_adiacents += 1 
elsif char > next_char
    return false
end
}
if checks_adiacents == 0 
    return false
end

return true 
end


counter_valid = 0;
range.each{|number|

    if check_valid(number)
        counter_valid += 1
    end

}
puts('Part One: ')
puts (counter_valid)



