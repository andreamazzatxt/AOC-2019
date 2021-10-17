require_relative '../common/intcode'
input = File.read('13.txt').split(',').map(&:to_i)

class Tile
    attr_reader :x, :y
    def initialize(instruction)
        @x, @y = instruction[0], instruction[1]
        @type = instruction[2]
    end

    def type
        case @type
        when 0
            return :empty
        when 1
            return :wall
        when 2
            return :block
        when 3 
            return :paddle
        when 4 
            return :ball
        end
    end
end

class ArcadeCabinet
    attr_reader :grid, :joystick_position

    TILE_MAPPING = {
        empty: ' ',
        wall: '|',
        block: 'X',
        paddle: '-',
        ball: '@'

    }
    def initialize(input)
        input[0] = 2
        @brain = IntCode.new(input)
        @instructions = @brain.decode!()[:result].each_slice(3).to_a
        @grid = []
        create_grid
        @score = 0
        @current_paddle = 0
        @current_ball = 0
    end

    def create_grid
        @instructions.each do |instruction|
            tile = Tile.new(instruction)
            row = @grid[tile.y] || []
            row[tile.x] = tile.type
            @grid[tile.y] = row
        end
        return self
    end

    def play
        @grid.each_with_index do |row, y|
             row.each_with_index do |tile, x|
                @current_paddle = x if tile == :paddle
                @current_ball = x if tile == :ball
             end
        end
        output = []
        until @brain.halted?
            input =  @current_ball <=> @current_paddle
            @current_paddle = @current_ball
            output = @brain.decode!(input)[:result].last(12).each_slice(3).to_a
            output.each do |ist|
                use_output ist
            end
        end
        return @score
    end

    def count(type)
        counter = 0
        @grid.each do |row|
            count = row.tally[:block]
            counter += count if count
        end
        counter
    end

    def use_output(output)
        if output[0] == -1 && output[1] == 0
                @score = output[2]
            else 
                tile = Tile.new(output)
                case tile.type
                when :ball
                     @current_ball = tile.x
                when :paddle
                    @current_paddle = tile.x
                end
            end
    end

    def display
        @grid.each do |row|
            puts row.map { |tile| TILE_MAPPING[tile] }.join('')
        end
        puts "SCORE #{@score}"
    end
end

cabinet = ArcadeCabinet.new(input.clone)
puts 'Part One:'
p cabinet.count(:block)
cabinet.display

puts 'Part Two:'
p cabinet.play

