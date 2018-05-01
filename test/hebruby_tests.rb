# coding:utf-8

# Unit tests for Hebruby module to convert julian dates to hebrew dates, and vice-versa
# Written by Ron Evans
# Additional code contributed by Joshua Harvey
# Based on Javascript code from John Walker (http://www.fourmilab.ch/documents/calendar/)
require 'test/unit'
require File.dirname(__FILE__)+'/../lib/hebruby'
require 'date'

class TC_MyTest2 < Test::Unit::TestCase
  # def setup
  # end

  # def teardown
  # end

  #
  # hebrew to julian tests
  #

  def test_h2j_1
    @hb = Hebruby::HebrewDate.new(Date.new(2010, 1, 1))
    assert_equal(10, @hb.month, "Wrong month.")
    assert_equal("Tevet", @hb.month_name, "Wrong month name.")
    assert_equal(5770, @hb.year, "Wrong year.")
    assert_equal(15, @hb.day, "Wrong day.")
    assert_equal("ט\"ו", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_2
    @hb = Hebruby::HebrewDate.new(Date.new(2005, 1, 15))
    assert_equal(11, @hb.month, "Wrong month.")
    assert_equal("Shvat", @hb.month_name, "Wrong month name.")
    assert_equal(5765, @hb.year, "Wrong year.")
    assert_equal(5, @hb.day, "Wrong day.")
    assert_equal("ה'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_3
    @hb = Hebruby::HebrewDate.new(Date.new(2005, 4, 10))
    assert_equal(1, @hb.day, "Wrong day.")
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(5765, @hb.year, "Wrong year.")
    assert_equal("א'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_4
    @hb = Hebruby::HebrewDate.new(Date.new(1966, 4, 10))
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(5726, @hb.year, "Wrong year.")
    assert_equal(20, @hb.day, "Wrong day.")
    assert_equal("כ'", @hb.heb_day_name, "Wrong heb day.")
  end

  #using the same date as the previous test, this time we pass
  #an integer rather than a Date object
  def test_julianday_integer
    @hb = Hebruby::HebrewDate.new(Date.new(1966, 4, 10).jd)
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(5726, @hb.year, "Wrong year.")
    assert_equal(20, @hb.day, "Wrong day.")
    assert_equal("כ'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_5
    @hb = Hebruby::HebrewDate.new(Date.new(1998, 12, 22))
    assert_equal(10, @hb.month, "Wrong month.")
    assert_equal("Tevet", @hb.month_name, "Wrong month name.")
    assert_equal(5759, @hb.year, "Wrong year.")
    assert_equal(3, @hb.day, "Wrong day.")
    assert_equal("ג'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_6
    @hb = Hebruby::HebrewDate.new(Date.new(1968, 6, 28))
    assert_equal(4, @hb.month, "Wrong month.")
    assert_equal("Tamuz", @hb.month_name, "Wrong month name.")
    assert_equal(5728, @hb.year, "Wrong year.")
    assert_equal(2, @hb.day, "Wrong day.")
    assert_equal("ב'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_7
    @hb = Hebruby::HebrewDate.new(Date.new(1941, 12, 10))
    assert_equal(9, @hb.month, "Wrong month.")
    assert_equal("Kislev", @hb.month_name, "Wrong month name.")
    assert_equal(5702, @hb.year, "Wrong year.")
    assert_equal(20, @hb.day, "Wrong day.")
    assert_equal("כ'", @hb.heb_day_name, "Wrong heb day.")
  end

  #Test the 30th of a 30-day month
  def test_h2j_8
    @hb = Hebruby::HebrewDate.new(Date.new(2009, 4, 24))
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(5769, @hb.year, "Wrong year.")
    assert_equal(30, @hb.day, "Wrong day.")
    assert_equal("ל'", @hb.heb_day_name, "Wrong heb day.")
  end
  #
  #Test the 29th of a 29-day month
  def test_h2j_9
    @hb = Hebruby::HebrewDate.new(Date.new(2008, 1, 7))
    assert_equal(10, @hb.month, "Wrong month.")
    assert_equal("Tevet", @hb.month_name, "Wrong month name.")
    assert_equal(5768, @hb.year, "Wrong year.")
    assert_equal(29, @hb.day, "Wrong day.")
    assert_equal("כ\"ט", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_h2j_10
    @hb = Hebruby::HebrewDate.new(Date.new(2005, 3, 18))
    assert_equal(13, @hb.month, "Wrong month.")
    assert_equal("Adar Sheni", @hb.month_name, "Wrong month name.")
    assert_equal(5765, @hb.year, "Wrong year.")
    assert_equal(7, @hb.day, "Wrong day.")
    assert_equal("ז'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_jd
    orig=2454946

    assert_equal(orig,Hebruby::HebrewDate.to_jd(*
      Hebruby::HebrewDate.jd_to_hebrew(orig)),
      "Julian day number #{orig} didn't make a round trip using class methods")

    hb=Hebruby::HebrewDate.new(orig)
    hb.convert_from_julian
    hb.convert_from_hebrew
    assert_equal(orig,hb.jd,
      "Julian day number #{orig} didn't make a round trip using instance methods")
  end

  def test_to_jd
    assert_equal(2454944,Hebruby::HebrewDate.to_jd(5769,1,28))
    assert_equal(2454945,Hebruby::HebrewDate.to_jd(5769,1,29))
    assert_equal(2454946,Hebruby::HebrewDate.to_jd(5769,1,30))
  end

  #
  # julian to hebrew tests
  #

  def test_j2h_1
    @hb = Hebruby::HebrewDate.new(15,10,5770)
    assert_equal(15, @hb.day, "Wrong day.")
    assert_equal(10, @hb.month, "Wrong month.")
    assert_equal("Tevet", @hb.month_name, "Wrong month name.")
    assert_equal(5770, @hb.year, "Wrong year.")
    assert_equal('התש"ע', @hb.heb_year_name, "Wrong year.")
    assert_equal(Date.new(2010, 1, 1).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("ט\"ו", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_2
    @hb = Hebruby::HebrewDate.new(5,11,5765)
    assert_equal(5, @hb.day, "Wrong day.")
    assert_equal(11, @hb.month, "Wrong month.")
    assert_equal("Shvat", @hb.month_name, "Wrong month name.")
    assert_equal(5765, @hb.year, "Wrong year.")
    assert_equal(Date.new(2005, 1, 15).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("ה'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_3
    @hb = Hebruby::HebrewDate.new(1,1,5765)
    assert_equal(1, @hb.day, "Wrong day.")
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(5765, @hb.year, "Wrong year.")
    assert_equal(Date.new(2005, 4, 10).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("א'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_4
    @hb = Hebruby::HebrewDate.new(20,1,5726)
    assert_equal(20, @hb.day, "Wrong day.")
    assert_equal(1, @hb.month, "Wrong month.")
    assert_equal(5726, @hb.year, "Wrong year.")
    assert_equal("Nissan", @hb.month_name, "Wrong month name.")
    assert_equal(Date.new(1966, 4, 10).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("כ'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_5
    @hb = Hebruby::HebrewDate.new(3,10,5759)
    assert_equal(3, @hb.day, "Wrong day.")
    assert_equal(10, @hb.month, "Wrong month.")
    assert_equal("Tevet", @hb.month_name, "Wrong month name.")
    assert_equal(5759, @hb.year, "Wrong year.")
    assert_equal(Date.new(1998, 12, 22).jd, @hb.jd, "Wrong Julian date.")
    assert_equal(%q{ג' בטבת התשנ"ט}, @hb.heb_date)
    assert_equal("ג'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_6
    @hb = Hebruby::HebrewDate.new(2,4,5728)
    assert_equal(2, @hb.day, "Wrong day.")
    assert_equal(4, @hb.month, "Wrong month.")
    assert_equal("Tamuz", @hb.month_name, "Wrong month name.")
    assert_equal("תמוז", @hb.heb_month_name, "Wrong month name.")
    assert_equal(5728, @hb.year, "Wrong year.")
    assert_equal('התשכ"ח', @hb.heb_year_name, "Wrong year.")
    assert_equal(Date.new(1968, 6, 28).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("ב'", @hb.heb_day_name, "Wrong heb day.")
  end

  def test_j2h_7
    @hb = Hebruby::HebrewDate.new(20,9,5702)
    assert_equal(20, @hb.day, "Wrong day.")
    assert_equal(9, @hb.month, "Wrong month.")
    assert_equal("Kislev", @hb.month_name, "Wrong month name.")
    assert_equal("כסלו", @hb.heb_month_name, "Wrong month name.")
    assert_equal(5702, @hb.year, "Wrong year.")
    assert_equal('התש"ב', @hb.heb_year_name, "Wrong year.")
    assert_equal(Date.new(1941, 12, 10).jd, @hb.jd, "Wrong Julian date.")
    assert_equal("כ'", @hb.heb_day_name, "Wrong heb day.")
  end

end
