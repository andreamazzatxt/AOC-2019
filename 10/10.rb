require 'prime'

input = File.read('10.txt').split(/\n/).map{|line| line.split('')}
XLEN = input.size
YLEN = input[0].size
# input.each do |row|
#     p row
# end
# Asteroids Coordinates
asteroids = []
input.each_with_index do |row, x|
    input.each_with_index do |column, y|
        asteroids << [x,y] if input[y][x] == '#'
    end
end
counts = []

def slope(base, asteroid)
    x_dist = asteroid[0] - base[0]
    y_dist = asteroid[1] - base[1]
    slope = y_dist / x_dist.to_f
    return "#{slope}-#{asteroid[0]+asteroid[1] > base[0] + base[1] ? 'front' : 'back'}"
end

asteroids.each do |candidate|
    counts << asteroids.map{ |asteroid| slope(candidate, asteroid)}.uniq.count
end

puts 'Part One'
p counts.max