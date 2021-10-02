WIDTH = 25
HEIGHT = 6
COUNT = WIDTH * HEIGHT
layers = File.read('8.txt').split('').each_slice(COUNT).to_a

def count_elem(array, elem )
    array.select{ |num| num == elem}.count()
end

result_layer = layers.reduce do |result, layer| 
    count_elem(result, '0') < count_elem(layer, '0') ? result : layer 
end

puts "First: #{(count_elem result_layer, '1') * (count_elem result_layer, '2')}"

image = layers.reduce do |final, layer|
    final = final.map.with_index do |value, index|
        value == '2' ?  layer[index] : value
    end
end

image.each_slice(WIDTH).each do |line|
    puts line.map{|value| (value == '1') ? '⬛️' : '⬜'}.join('')
end
️