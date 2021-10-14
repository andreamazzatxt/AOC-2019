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
candidates = []

def slope(base, asteroid)
    x_dist = asteroid[0] - base[0]
    y_dist = asteroid[1] - base[1]
    slope = (Math.atan2(-y_dist, x_dist)*180) / Math::PI
    if (slope <= 90 && slope >= 0)
        slope = (slope - 90).abs;
    elsif (slope < 0)
        slope = slope.abs + 90;
    else
        slope = 450 - slope;
    end
    return  slope
end

def distance(base, asteroid)
    Math.sqrt((asteroid[1] - base[1])**2 + (asteroid[0] - base[0])**2)
end

asteroids.each do |candidate|
    candidates << {
        coord: candidate,
        count: asteroids.map{ |asteroid| slope(candidate, asteroid)}.uniq.count
    }
end

base = candidates.max_by{|candidate| candidate[:count] }[:coord]
puts 'Part One'
p candidates.max_by{|candidate| candidate[:count] }[:count]


asteroids = asteroids.delete_if { |asteroid| asteroid[0] == base[0] && asteroid[1] == base[1] }
slope_mapping = {}
asteroids.each do |asteroid|
    slope = slope(base, asteroid)
    slope_mapping[slope] = [] if !slope_mapping[slope]
    slope_mapping[slope] << {
        coord: asteroid,
        dist: distance(base, asteroid)
    }
end

laser_ordered = slope_mapping.sort
                                .to_h
                                .values
                                .map {|asteroids_line| asteroids_line
                                        .sort_by{ |ast| ast[:dist] }
                                        .map{|ast| ast[:coord]}}
vaporized = []

until vaporized.size == asteroids.size
    laser_ordered = laser_ordered.map do |asteroids|
        vaporized << asteroids[0]
        asteroids.drop(1)
    end
    laser_ordered.reject! {|v| v.size.zero?}
end

puts 'Part Two'
p vaporized[199][0] * 100 +vaporized[199][1]