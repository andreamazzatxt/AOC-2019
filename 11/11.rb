require_relative '../common/intcode'

input = File.read('11.txt').split(',').map {|num| num.to_i}
position = {
    x: 0,
    y: 0
}

class PaintingBot
    #           0       1       2      3
    FACINGS = [:up, :right, :down, :left].freeze
    def initialize(program)
        @brain = IntCode.new(program)
        # 0: black 1: white
        @map = {
            '0/0': 0
        }
        @facing = 0
        @current_pos = { 
            x: 0,
            y: 0
        }
        @paint_counter = 0
    end

    def start
        color = @map[position_to_s(@current_pos)]
        output =  @brain.decode!(color)
        return [@map, @paint_counter] if @brain.halted?
        instruction = output[:result].last(2)
        paint(@current_pos, instruction[0])
        move(instruction[1])
        start()
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

    def paint(coord, color)
        @paint_counter += 1
        @map[position_to_s(coord)] = color 
    end

    def add_position_to_map(coord)
        @map[position_to_s(coord)] = 0 unless @map[position_to_s(coord)]
    end

end

painter = PaintingBot.new(input)
map = painter.start
 p 'Part One'
p map[0].count