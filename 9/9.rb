input = File.read('9.txt').split(',').map { |int| int.to_i}
class IntCode
    def initialize(instructions, inputs = [])
        @instructions = instructions
        @inputs = inputs
        @status = :continue
        @relative_base = 0
        @pointer = 0
        @result = []
    end

    def decode!(input = nil)
        @status = :continue
        @inputs << input if !input.nil?
        while @status == :continue && @instructions[@pointer] != 99
            instruction = parse_instruction @instructions[@pointer]
            input1 = parse_input instruction[:mode], 1
            input2 = parse_input instruction[:mode], 2

            case instruction[:opcode]
            when 1
                handle_one input1, input2, get_destination(instruction[:mode], 3)
            when 2
                handle_two input1, input2, get_destination(instruction[:mode], 3)
            when 3
                handle_three get_destination(instruction[:mode], 1)
            when 4 
                handle_four input1
            when 5
                handle_five input1, input2
            when 6 
                handle_six input1, input2
            when 7
                handle_seven input1, input2, get_destination(instruction[:mode], 3)
            when 8 
                handle_eight input1, input2, get_destination(instruction[:mode], 3)
            when 9 
                handle_nine input1 
            else
               raise(' ERROR : OP-Code not Valid ' + @instructions[@pointer].to_s) 
            break
            end
        end
        @status = :halt if @instructions[@pointer] == 99
        return @result
    end

    def halted?
        @status == :halt
    end

    private

    def parse_input(modes, input)
        sym = input == 1 ? :one : :two
        case modes[sym]
        when 0
            #position mode
            return @instructions[@instructions[@pointer + input]] || 0
        when 1
            #immediate mode
            return @instructions[@pointer + input] || 0
        when 2
            #relative mode
            return  @instructions[@relative_base + @instructions[@pointer + input]] || 0
        else 
            raise 'parse input error'
            
        end
    end

    def get_destination(modes, input)
        sym = input == 1 ? :one : (input == 2 ? :two : :three)
        case modes[sym]
        when 0
            #position mode
            return @instructions[@pointer + input]
        when 1
            #immediate mode
            return @pointer + input
        when 2
            #relative mode
            return  @relative_base + @instructions[@pointer + input]
        else 
            raise 'parse input error'
            
        end
    end

    def handle_one(input1, input2, destination)
        @instructions[destination] = input1 + input2
        @pointer = @pointer + 4
    end

    def handle_two(input1, input2, destination)
        @instructions[destination] = input1 * input2
        @pointer = @pointer + 4
    end

    def handle_three(destination)
        @instructions[destination] = @inputs.shift
        @pointer = @pointer + 2

    end

    def handle_four(input1)
        @result << input1
        @pointer = @pointer + 2
    end

    def handle_five(input1, input2)
        if !input1.zero?
            @pointer = input2
        else
            @pointer = @pointer + 3
        end
    end

    def handle_six(input1, input2)
        if input1.zero?
            @pointer = input2
        else
            @pointer = @pointer + 3
        end
    end

    def handle_seven(input1, input2, destination)
        @instructions[destination] = input1 < input2 ? 1 : 0
        @pointer = @pointer + 4
    end

    def handle_eight(input1, input2, destination)
        @instructions[destination] = input1 == input2 ? 1 : 0
        @pointer = @pointer + 4
    end

    def handle_nine(input1)
        @relative_base = @relative_base + input1
        @pointer = @pointer + 2
    end


    def parse_instruction(instruction)
        instruction = instruction.to_s.rjust(5, '0')
        {
            opcode: instruction[3..4].to_i,
            mode: {
                one: instruction[2].to_i,
                two: instruction[1].to_i,
                three: instruction[0].to_i
            }
        }
    end
end

puts 'Part One: '
p IntCode.new(input).decode!(1)

puts 'Part Two:'
p IntCode.new(input).decode!(2)