input = File.read('7.txt').split(',').map { |int| int.to_i}
class IntCode
    def initialize(inputs, options)
        @instructions = inputs
        @options = options
        @status = :continue
        @current = 0
        @result = 0
    end

    def decode!(value = nil)
        @status = :continue
        @options << value if !value.nil?
        while @status == :continue && @instructions[@current] != 99
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
            when 5
                handle_five instruction[:mode]
            when 6 
                handle_six instruction[:mode]
            when 7
                handle_seven instruction[:mode]
            when 8 
                handle_eight instruction[:mode]
            else
               puts(' ERROR : OP not Valid ' + @instructions[@current].to_s) 
            break
            end
        end
        @status = :halt if @instructions[@current] == 99
        return @result
    end

    def halted?
        @status == :halt
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
        input1 = @options.shift
        target = @instructions[@current + 1]
        @instructions[target] = input1
        @current = @current + 2
    end

    def handle_four(modes)
        @status= :pause
        @result = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1]
        @current = @current + 2
    end

    def handle_five(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        if !input1.zero?
            @current = input2
        else
            @current = @current + 3
        end
    end

    def handle_six(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        if input1.zero?
            @current = input2
        else
            @current = @current + 3
        end
    end

    def handle_seven(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        target = @instructions[@current + 3]
        @instructions[target] = input1 < input2 ? 1 : 0
        @current = @current + 4
    end

    def handle_eight(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@current + 1]] : @instructions[@current + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@current + 2]] : @instructions[@current + 2]
        target = @instructions[@current + 3]
        @instructions[target] = input1 == input2 ? 1 : 0
        @current = @current + 4
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

phases_comb = [5, 6, 7 , 8, 9].permutation(5).to_a
highest = 0

class Circuit
    def initialize(input, phases)
        @phases = phases
        @amp_a = IntCode.new(input, [phases[0]])
        @amp_b = IntCode.new(input, [phases[1]])
        @amp_c = IntCode.new(input, [phases[2]])
        @amp_d = IntCode.new(input, [phases[3]])
        @amp_e = IntCode.new(input, [phases[4]])
        @circuit = [@amp_a, @amp_b, @amp_c, @amp_d, @amp_e]
    end

    def run!
        current_output = 0
        while !@amp_e.halted?
            current_output = @circuit.reduce(current_output) do |value, amp|
                amp.decode!(value)
            end
        end
        return current_output
    end
end

phases_comb.each do |phases|
   output = Circuit.new(input, phases).run!
   highest = output if output > highest
end

puts 'Part Two: '
p highest
