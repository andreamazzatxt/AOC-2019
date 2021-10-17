input = File.read('12.txt').split(/\n/).map do |line|
    line.gsub('>', '')
        .split(',')
end
input.map! do |line|
    line.map{ |pos| pos.split('=')[1].to_i}
end

MOON_NAMES = %w(io europa ganymede callisto)

class Moon
    attr_accessor :name, :x, :y, :z
    def initialize (name, coord)
        @name = name
        @x = coord[0].clone
        @y = coord[1].clone
        @z = coord[2].clone
        @vel_x = 0
        @vel_y = 0
        @vel_z = 0
    end

    def update_velocity(moon_b)
        @vel_x += -(@x <=> moon_b.x)
        @vel_y += -(@y <=> moon_b.y)
        @vel_z += -(@z <=> moon_b.z)
    end

    def update_positon
        @x += @vel_x
        @y += @vel_y
        @z += @vel_z
    end

    def potential_energy
        @x.abs + @y.abs + @z.abs 
    end

    def kinetick_energy
        @vel_x.abs + @vel_y.abs + @vel_z.abs
    end

    def total_energy
        potential_energy * kinetick_energy
    end

    def print
        p @name
        p "POSITION x: #{@x}, y: #{@y}, z: #{@z}"
        p "VELOCITY x: #{@vel_x}, y: #{@vel_y}, z: #{@vel_z}"
    end
end

class Simulation 
    attr_reader :moons
    def initialize(input)
        @steps = 0
        @moons = []
        input.each_with_index do |moon, index|
            @moons << Moon.new(MOON_NAMES[index], moon)
        end
    end

    def step
        @moons.combination(2) do |moon_a, moon_b|
            moon_a.update_velocity moon_b
            moon_b.update_velocity moon_a
        end
        @moons.each do |moon|
             moon.update_positon
        end
        @steps += 1
    end

    def make_steps(n)
        steps = 0
        until steps == n
            step
            steps += 1
        end
    end

    def energy 
        @moons.map{|moon| moon.total_energy}.reduce(&:+)
    end

    def print_status
        puts "Steps taken : #{@steps}"
        @moons.each {|moon| moon.print}
    end
end

simulation = Simulation.new(input)
simulation.make_steps 1000
puts 'Part One:'
p simulation.energy
