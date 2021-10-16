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
            dest1 = get_destination instruction[:mode], 1
            dest2 = get_destination instruction[:mode], 2
            dest3 = get_destination instruction[:mode], 3

            case instruction[:opcode]
            when 1
                @instructions[dest3] = (@instructions[dest1] || 0) +( @instructions[dest2] || 0)
                @pointer += 4
            when 2
                @instructions[dest3] = (@instructions[dest1] || 0) * (@instructions[dest2] || 0)
                @pointer += 4
            when 3
                if @inputs.size.zero?
                    @status= :pause
                elsif 
                    @instructions[dest1] = @inputs.shift
                    @pointer += 2
                end
            when 4 
                @result << @instructions[dest1]
                @pointer += 2
            when 5
                if !@instructions[dest1].zero?
                    @pointer = @instructions[dest2]
                else
                    @pointer += 3
                end
            when 6 
                if @instructions[dest1].zero?
                    @pointer = @instructions[dest2]
                else
                    @pointer += 3
                end
            when 7
                @instructions[dest3] = @instructions[dest1] < @instructions[dest2] ? 1 : 0
                @pointer += 4
            when 8 
                @instructions[dest3] = @instructions[dest1] == @instructions[dest2] ? 1 : 0
                @pointer += 4
            when 9 
                @relative_base = @relative_base + @instructions[dest1]
                @pointer = @pointer + 2
            else
                raise('OPCode not Valid :( ' + @instructions[@pointer].to_s) 
            break
            end
        end
        @status = :halt if @instructions[@pointer] == 99
        return {result: @result, status: @status}
    end

    def halted?
        @status == :halt
    end

    private

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
