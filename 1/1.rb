file_data = File.read("1.txt").split
count = 0;
file_data.each { |number|
    number = number.to_i
    count = count + ((number/3)-2)
}

puts('Part One ' + count.to_s)

count_two =  0 

file_data.each {|number|
    count = 0
    mass = number.to_i
    fuel = (mass/3)-2
    count = count + fuel
    while true
        mass  = fuel
        fuel = (mass/3)-2
        if ( fuel > 0 )
            count = count +fuel
        else 
            break
        end 
    end
    count_two += count

}
puts('Part two : ' + count_two.to_s)