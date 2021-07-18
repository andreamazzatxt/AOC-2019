input = File.read('5.txt').split(',').map { |int| int.to_i}

class IntCode
    def initialize(input)
        @instructions = input
        @current = 0
    end

    def decode!
        while @instructions[@current] != 99
            instruction = parse_instruction @instructions[@current]
            case instruction[:opcode]
            when 1
                handle_one instruction[:mode]
            when 2
                handle_two instruction[:mode]
            when 3
                handle_three instruction[:mode]
            when 4 
                handle_four instruction[:mode]
            else
               puts(' ERROR : OP not Valid ' + @instructions[@current].to_s) 
            break
            end
        end
    end

    private

    def handle_one(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        target = @instructions[@current + 3]
        @instructions[target] = input1 + input2
        @current = @current + 4
    end

    def handle_two(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        target = @instructions[@current + 3]
        @instructions[target] = input1 * input2
        @current = @current + 4
    end

    def handle_three(modes)
        input1 = ask_integer
        target = @instructions[@current + 1]
        @instructions[target] = input1
        @current = @current + 2
    end

    def handle_four(modes)
        target = @instructions[@current + 1]
        puts @instructions[target]
        @current = @current + 2
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

    def ask_integer
        puts 'I need your input :'
        return gets.chomp.to_i
    end
end

decoder = IntCode.new(input)
decoder.decode!