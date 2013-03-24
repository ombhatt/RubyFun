
#!/usr/bin/env ruby


class CSSCompressor
    attr_accessor :input_file
    
    def self.comment_regexp
        @@comment_regexp
    end

    def initialize(input)
        @input_file = File.open(input, "r")
        @@comment_regexp = /\/\*.*?\*\//m
    end

    def compress_to(output)
        output_file = File.open(output, "w")

        # first remove the comments
        input = @input_file.read
        result = input.gsub(@@comment_regexp, '').split("\n")

        # then, remove the blank lines
        # doing other way round had blank lines on comment
        # substitution

        noblanks = ""
        result.each do |line| 
            begin
                if line.strip.length != 0 
                    noblanks << line 
                    noblanks << "\n"
                end
            end
        end

        # write compressed input to output file
        output_file.write(noblanks)

        output_file.close
        @input_file.close
    end
end

