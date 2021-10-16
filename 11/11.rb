require_relative '../common/intcode'

input = File.read('11.txt').split(',').map {|num| num.to_i}

class PaintingBot
    #           0       1       2      3
    FACINGS = [:up, :right, :down, :left].freeze
    def initialize(program, starting_color = 0)
        @brain = IntCode.new(program)
        # 0: black 1: white
        @map = {
            '0/0': starting_color
        }
        @facing = 0
        @current_pos = { 
            x: 0,
            y: 0
        }
    end

    def start

        until @brain.halted?
        color = @map[position_to_s(@current_pos)]
        output = @brain.decode!(color)
        instruction = output[:result].last(2)
        paint(@current_pos, instruction[0])
        move(instruction[1])    
        end
        return @map
    end

    def paint_map
        @map = @map.map do |coord, color|
            coord = string_to_pos(coord)
            coord[:y] += 5
            [coord, color]
        end
        x_max = @map.max_by { |coord| coord[0][:x]}[0][:x]
        y_max = @map.max_by { |coord| coord[0][:y]}[0][:y]
        picture = []
        @map.each do |panel|
            coord = panel[0]
            row = picture[panel[0][:y]] || []
            row[panel[0][:x]] = panel[1].zero? ? ' ' : '#'
            picture[panel[0][:y]] = row
        end
        picture.reverse.map do |line| 
            puts line.join(' ')
        end
    end


    private

    def move(instruction)
        if instruction == 1
            @facing = (@facing + 1 ) % 4 
        elsif instruction == 0
            @facing = (@facing - 1) % 4
        else 
            raise 'Wrong Instruction'
        end

        case FACINGS[@facing]
        when :up
            @current_pos[:y] += 1
        when :down
            @current_pos[:y] -= 1
        when :right
            @current_pos[:x] += 1
        when :left
            @current_pos[:x] -= 1
        else 
            raise 'Wrong Direction Symbol'
        end
        add_position_to_map @current_pos
    end

    def position_to_s(position)
        return "#{position[:x].to_s}/#{position[:y].to_s}".to_sym
    end

    def string_to_pos(string)
        coord = string.to_s.split('/').map{|val| val.to_i}
        return { 
            x: coord[0],
            y: coord[1]
        }
    end

    def paint(coord, color)
        @map[position_to_s(coord)] = color 
    end

    def add_position_to_map(coord)
        @map[position_to_s(coord)] = 0 unless @map[position_to_s(coord)]
    end

end

painter = PaintingBot.new(input,0)
map = painter.start
p 'Part One'
p map.count

# part 2

p 'Part Two: '
painter2 = PaintingBot.new(input,1)
painter2.start
painter2.paint_map