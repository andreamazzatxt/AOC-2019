require 'colorize'
input = File.read('3.txt').split
wires = []
input.each{ |wire|
    line = wire.split(',')
    wires.push(line)
}

def find_path(cable) 
$coord_first_cable = {x:0,y:0}
$first_cable = [{x:0,y:0}]
 cable.each{ |instruction|
    #first cable 
    direction = instruction[0]
    $steps = instruction[1..].to_i
    case direction
    when 'U'
        diff = $coord_first_cable[:y] + $steps;
        $first_cable.push({x: $coord_first_cable[:x], y:diff})
        $coord_first_cable[:y] += $steps
    when 'D'
        diff = $coord_first_cable[:y] - $steps;
        $first_cable.push({x: $coord_first_cable[:x], y:diff})
        $coord_first_cable[:y] -= $steps
    when 'L'
        diff = $coord_first_cable[:x] - $steps
        $first_cable.push({x:diff, y:$coord_first_cable[:y]})
        $coord_first_cable[:x] -= $steps
    when 'R'
        diff = $coord_first_cable[:x] + $steps
        $first_cable.push({x:diff, y:$coord_first_cable[:y]})
        $coord_first_cable[:x] += $steps
    end

 }
 return $first_cable

end


first_pattern = find_path(wires[0]);
second_pattern = find_path(wires[1]);
$manhattans = []
first_pattern.each_with_index{|vertex1,index1|
    next_vertex1 = first_pattern[index1+1] ? first_pattern[index1+1] : vertex1
    type1 = next_vertex1[:x] == vertex1[:x] ? 'vertical' : 'horizontal'
    second_pattern.each_with_index{|vertex2,index2|
    next_vertex2 = second_pattern[index2+1] ? second_pattern[index2+1] : vertex2
    type2 = next_vertex2[:x] == vertex2[:x] ? 'vertical' : 'horizontal'
    count = 0 

        if type1 != type2
            if type1 == 'vertical'
                x_range = [vertex2[:x],next_vertex2[:x]].sort!
                y_range = [vertex1[:y],next_vertex1[:y]].sort!
                if vertex1[:x].between?(x_range[0],x_range[1]) && vertex2[:y].between?(y_range[0],y_range[1])
                    manhattan = vertex1[:x].abs() + vertex2[:y].abs()
                    $manhattans.push({
                        x:vertex1[:x],
                        y:vertex2[:y],
                        manhattan: manhattan,
                    })
                end
                
            elsif type2 == 'vertical'
                x_range = [vertex1[:x],next_vertex1[:x]].sort!
                y_range = [vertex2[:y],next_vertex2[:y]].sort!
                if vertex2[:x].between?(x_range[0],x_range[1]) && vertex1[:y].between?(y_range[0],y_range[1])
                    manhattan = vertex2[:x].abs() + vertex1[:y].abs()
                    $manhattans.push({
                        x: vertex2[:x],
                        y:vertex1[:y],
                        manhattan: manhattan,
                    })
                end
            end
        end
}
}

result = {
    x:nil,
    y:nil,
    manhattan:nil,
}

$manhattans.each{|intersection|
    if result[:manhattan] == nil  && intersection[:manhattan] != 0
        result = intersection
    elsif  intersection[:manhattan] != 0 && intersection[:manhattan] < result[:manhattan] 
        result = intersection
    end

}
puts('Part One:'.colorize(:yellow))
puts(result[:manhattan])

#find shortest path in steps
 dic_of_path = {}


 $manhattans.each{|intersection|
    x = intersection[:x]
    y = intersection[:y]
    dic_of_path[intersection[:manhattan]] = 0
    counter = 1
    counter2 = 0
    #first cable

    first_pattern.each_with_index{|step,index|
        
        next_step = first_pattern[index+1] ? first_pattern[index+1] : step
        #horizontal
        if step[:y] == next_step[:y]
            if step[:x] < next_step[:x]
                range = (step[:x]+1).upto(next_step[:x])
            else
                range = (step[:x]-1).downto(next_step[:x])
            end
            range.each{|x_variation|
                if x  == x_variation && step[:y] == y
                    counter += 1
                    dic_of_path[intersection[:manhattan]] += counter

                else
                    counter += 1
                end
            }
        #vertical 
        elsif step[:x] == next_step[:x]
            if step[:y] < next_step[:y]
                range = (step[:y]+1).upto(next_step[:y])
            else
                range = (step[:y]-1).downto(next_step[:y])
            end
            range.each{|y_variation|
            if y == y_variation && step[:x] == x
                counter += 1
                dic_of_path[intersection[:manhattan]] += counter
            else
                counter += 1
            end
            }

        end
    }
    #second cable
    second_pattern.each_with_index{|step,index|
        next_step = second_pattern[index+1] ? second_pattern[index+1] : step
        #horizontal
        if step[:y] == next_step[:y]
            if step[:x] < next_step[:x]
                range = (step[:x]+1).upto(next_step[:x])
            else
                range = (step[:x]-1).downto(next_step[:x])
            end
            range.each{|x_variation|
                if x  == x_variation && step[:y] == y
                    dic_of_path[intersection[:manhattan]] += counter2  
                else
                    counter2 += 1
                end
            }
        #vertical 
        elsif step[:x] == next_step[:x]
            if step[:y] < next_step[:y]
                range = (step[:y]+1).upto(next_step[:y])
            else
                range = (step[:y]-1).downto(next_step[:y])
            end
            range.each{|y_variation|
            if y == y_variation && step[:x] == x
                dic_of_path[intersection[:manhattan]] += counter2
            else
                counter2 += 1
            end
            }

        end
    }
}
second_result = 0
dic_of_path.each{|name,value|
if second_result == 0 
    second_result = value
elsif second_result > value 
    second_result = value
end
}
puts('Part Two : '.colorize(:green))
puts( second_result)