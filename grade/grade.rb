
#!/usr/bin/env ruby

class Grade
    include Comparable

    attr_reader :grade
    attr_reader :str

    def initialize(input)
        if input.nil? 
             raise ArgumentError,"Expecting non-nil string parameter"
        end
        
        unparsed = input.strip
        if unparsed.length == 0 or unparsed.length > 2
             raise ArgumentError,"Expecting input of 1 or 2 characters"
        end

        letter = unparsed[0...1] #unparsed[0] didn't stick..

        # check for alphabet for first letter
        if !letter.match(/^[[:alpha:]]$/)
             raise ArgumentError,"Expecting alphabet character"
        end
        
        # Flip grade letter to do comparison, so A starts at 25
        # and Z goes to 0
        @grade = [ "Z"[0].ord - letter.upcase[0].ord ]

        # parse out the + or - qualifier if present
        symbol = unparsed[1...2] 
        if symbol.length == 0
            @grade << 0
        elsif symbol == "+"
            @grade << 1
        elsif symbol == "-"
            @grade << -1
        else
            raise ArgumentError,"Expecting + or - as second letter"
        end

        # for testing creation
        @str = input.upcase

    end

    def <=>(other)
        # create member array such that order is maintained
        # and use array's spaceship operator
        @grade <=> other.grade
    end
end

