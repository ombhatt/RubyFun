
#!/usr/bin/env ruby

require 'test/unit'
require 'css_compress'

class TestZDClient < Test::Unit::TestCase

    def test_css_compress_create_without_input
        assert_raise(Errno::ENOENT) { css_compressor = CSSCompressor.new("nofile.css") }
    end

    def test_css_compress_create_with_input
        css_compressor = CSSCompressor.new("valid.css")
        css_compressor.compress_to("valid_minify.css")
        check_file_compressed("valid_minify.css")
    end


    def test_css_compress_simple
        css_compressor = CSSCompressor.new("simple.css")
        css_compressor.compress_to("simple_minify.css")
        check_file_compressed("simple_minify.css")
    end

    def test_css_compress_multilinecomment
        css_compressor = CSSCompressor.new("multilinecomment.css")
        css_compressor.compress_to("multilinecomment_minify.css")
        check_file_compressed("multilinecomment_minify.css")
    end

    def test_css_compress_diffblanklines
        css_compressor = CSSCompressor.new("diffblanklines.css")
        css_compressor.compress_to("diffblanklines_minify.css")
        check_file_compressed("diffblanklines_minify.css")
    end

    def check_file_compressed(output)
        #check file exists
        file = File.open(output, "r")
        
        buffer = ""
        while (line = file.gets)
            if line.strip.length == 0
                assert(false, "File contains empty lines")
            else
                buffer << line
            end
        end
        if buffer =~ CSSCompressor::comment_regexp
            assert(false, "File still contains comments")
        end

        File.delete(output)
    end

    def test_reg_exp_no_comment
        test_string = "abcd /* efgh"
        assert_equal "abcd /* efgh", test_string.gsub(CSSCompressor::comment_regexp, '')
    end

    def test_reg_exp
        test_string = "abcd /* in comment */ efgh"
        assert_equal "abcd  efgh", test_string.gsub(CSSCompressor::comment_regexp, '')
    end
end
