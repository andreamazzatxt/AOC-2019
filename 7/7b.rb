input = File.read('7.txt').split(',').map { |int| int.to_i}
class IntCode
    def initialize(inputs, last = false)
        @instructions = inputs
        @state = :processing
        @pointer = 0
        @result = 0
        @nextAmp = nil
        @last = last
    end

    def decode!(input = nil)
        @input = input unless input.nil? 
        instruction = parse_instruction @instructions[@pointer]
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
            raise 'Error OPCODE'
        end

        case(@state)
        when :halt
            return @next_amp.decode!(@result) unless @last
            return @result
        when :processing
            decode!()
        end
    end

    def send_to(send_to)
        @next_amp = send_to
    end

    def set_phase(phase)
        @phase = phase
    end

    private

    def handle_one(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        target = @instructions[@pointer + 3]
        @instructions[target] = input1 + input2
        @pointer = @pointer + 4
    end

    def handle_two(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        target = @instructions[@pointer + 3]
        @instructions[target] = input1 * input2
        @pointer = @pointer + 4
    end

    def handle_three(modes)
        target = @instructions[@pointer + 1]
        @instructions[target] = @input
        @pointer = @pointer + 2
    end

    def handle_four(modes)
        @result = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1]
        @pointer = @pointer + 2
        @state = :halt
    end

    def handle_five(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        if !input1.zero?
            @pointer = input2
        else
            @pointer = @pointer + 3
        end
    end

    def handle_six(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        if input1.zero?
            @pointer = input2
        else
            @pointer = @pointer + 3
        end
    end

    def handle_seven(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        target = @instructions[@pointer + 3]
        @instructions[target] = input1 < input2 ? 1 : 0
        @pointer = @pointer + 4
    end

    def handle_eight(modes)
        input1 = modes[:one].zero? ? @instructions[@instructions[@pointer + 1]] : @instructions[@pointer + 1] 
        input2 = modes[:two].zero? ? @instructions[@instructions[@pointer + 2]] : @instructions[@pointer + 2]
        target = @instructions[@pointer + 3]
        @instructions[target] = input1 == input2 ? 1 : 0
        @pointer = @pointer + 4
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

class Circuit
    def initialize(input, phases)
        @ampE = IntCode.new(input, true)
        @ampD = IntCode.new(input)
        @ampC = IntCode.new(input)
        @ampB = IntCode.new(input)
        @ampA = IntCode.new(input)
        @ampA.send_to(@ampB)
        @ampB.send_to(@ampC)
        @ampC.send_to(@ampD)
        @ampD.send_to(@ampE)
        @ampE.send_to(@ampA)
        set_phases(phases)
    end

    def start!
        return @ampA.decode!(0)
    end
    private
    def set_phases(array)
        @ampA.set_phase(array[0])
        @ampB.set_phase(array[1])
        @ampC.set_phase(array[2])
        @ampD.set_phase(array[3])
        @ampE.set_phase(array[4])
    end
end

phases_comb = [9,8,7,6,5].permutation(5).to_a
highest = nil
phases_comb.each do |comb|
    circuit = Circuit.new(input,comb)
    result = circuit.start!
    highest = result if highest.nil? || result > highest
end


puts "Part Two: #{highest}"