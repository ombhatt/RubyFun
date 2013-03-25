#!/usr/bin/env ruby

require 'test/unit'
require 'grade'

class TestGrade <  Test::Unit::TestCase

    def test_nil
        begin
            inv = Grade.new()
            assert(false, "Expecting failure to create Grade")
        rescue => e
            assert(true, "Expected exception")
        end
    end

    def test_all_invalid_inputs
        check_invalid_strings("")
        check_invalid_strings("ABC")
        check_invalid_strings("90")
        check_invalid_strings("A1")
        check_invalid_strings("AA")
    end

    def test_all_valid_inputs
        check_valid_strings("A")
        check_valid_strings("B+")
        check_valid_strings("c-")
    end

    def test_grade_order_same_letter
        a_plus = Grade.new("A+")
        a = Grade.new("A")
        a_minus = Grade.new("A-")
        assert_equal(true,a_plus > a)
        assert_equal(true,a_plus > a_minus)
        assert_equal(false,a_minus > a)
        assert_equal(true,a_plus == a_plus)
    end

    def test_grade_order_diff_letter
        b_plus = Grade.new("B+")
        a_minus = Grade.new("A-")
        assert_equal(true,a_minus > b_plus)
        assert_equal(false,b_plus > a_minus)
    end

    def test_grade_order_same_letter
        grades = []
        grades << Grade.new("B+")
        grades << Grade.new("C-")
        grades << Grade.new("A+")
        grades << Grade.new("A")
        grades << Grade.new("A-")
        assert_equal([ Grade.new("C-"), Grade.new("B+"), Grade.new("A-"), Grade.new("A"), Grade.new("A+") ], grades.sort)
    end

    def check_invalid_strings(input)
        assert_raise(ArgumentError) {inv = Grade.new(input)}
    end

    def check_valid_strings(input)
        inv = Grade.new(input)
        assert_equal(input.upcase, inv.str)
    end

end
