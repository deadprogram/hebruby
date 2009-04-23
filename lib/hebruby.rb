# Hebruby is a Ruby library to convert julian dates to hebrew dates, and vice-versa.
# Written by Ron Evans (ron dot evans at gmail dot com or http://www.deadprogrammersociety.com).
# Additional code contributed by Joshua Harvey.
# Based on Javascript code from John Walker (http://www.fourmilab.ch/documents/calendar/).
# Usage:      
#       For julian to hebrew:
#             @hb = Hebruby::HebrewDate.new(Date.new(2010, 1, 1))
#             assert_equal(10, @hb.month, "Wrong month.")
#             assert_equal("Tevet", @hb.month_name, "Wrong month name.")
#             assert_equal(5770, @hb.year, "Wrong year.")
#             assert_equal(15, @hb.day, "Wrong day.")
#
#       For hebrew to julian:
#             @hb = Hebruby::HebrewDate.new1(15,10,5770)
#             assert_equal(Date.new(2010, 1, 1).jd, @hb.jd, "Wrong Julian date.")

require 'jcode'
$KCODE = 'u' # Always use UTF-8 internally!

module Hebruby

  class HebrewDate
    HEBREW_EPOCH = 347995
    MONTH_NAMES = %w{none Nissan Iyar Sivan Tamuz Av Elul Tishrei Chesvan Kislev Tevet Shvat Adar Veadar}
    HEB_MONTH_NAMES = [ nil, 'ניסן', 'אייר', 'סיון', 'תמוז', 'אב', 'אלול', 'תשרי', 
      'חשון', 'כסלו', 'טבת', 'שבט', 'אדר', 'אדר א\'', 'אדר ב\'']
    HEB_DAYS = [ nil, 'א\'', 'ב\'', 'ג\'', 'ד\'', 'ה\'', 'ו\'', 'ז\'', 'ח\'', 'ט\'', 
      'י\'', 'י"א', 'י"ב', 'י"ג', 'י"ד', 'ט"ו', 'ט"ז', 'י"ז', 'י"ח', 'י"ח', 
      'י"ט', 'כ\'' , 'כ"א', 'כ"ב', 'כ"ג', 'כ"ד', 'כ"ה', 'כ"ו', 'כ"ז', 'כ"ט', 'ל\'' ]
     ONES = [ '', 'א', 'ב', 'ג', 'ד', 'ה', 'ו', 'ז', 'ח', 'ט' ]
    TENS = [ '', 'י', 'כ', 'ל', 'מ', 'נ', 'ס', 'ע', 'פ', 'צ' ] 


    # Accessors for base Hebrew day, month, and year
   attr_accessor :hd, :hm, :hy
    
    # Constructor from another date object (which must respond to +#jd+), or
   # from a Julian day number. 
    def initialize(jd=nil)
      if jd
        if jd.is_a? Integer
          @jd = jd
        elsif jd.respond_to? :jd
          @jd = jd.jd
        end
        convert_from_julian
      end
    end
    
    # additional constructor from hebrew date to julian
    def self.new1(hd, hm, hy)
      me = new
      me.hd = hd
      me.hm = hm
      me.hy = hy
      me.convert_from_hebrew
      return me
    end
    
    def day
      return @hd
    end

  # Provide correct Hebrew transliterated month display name
    def month
      return @hm
    end

    # return Hebrew year converted from julian date
    def year
      return @hy
    end

    # return julian date converted from hebrew date
    def jd
      return @jd
    end
    
    # Provide correct Hebrew transliterated month display name
    def month_name
      return MONTH_NAMES[@hm]
    end

   # Provide correct Hebrew month display name
    def heb_month_name
      return HEB_MONTH_NAMES[@hm]
    end

   # Provide correct Hebrew day display name
    def heb_day_name
      return HEB_DAYS[@hd]
    end

   # Provide correct Hebrew year display name
    def heb_year_name
      year = @hy
      raise RangeError, "only 5700 - 5899 supported" if year < 5700 || year >= 5900
      prefix = year / 100 == 57 ? "התש" : "התת"
      suffix = HebrewDate.heb_number(year % 100)
      full = prefix + suffix
    end

   # Provide correct complete Hebrew display date
    def heb_date
      return heb_day_name + " ב" + heb_month_name + " " + heb_year_name
    end

   # Provide correct Hebrew number display
    def self.heb_number(num)
      return 'ט"ו' if num == 15
      return 'ט"ז' if num == 16
      if num < 10
        return '"' + ONES[ num % 10 ] 
      elsif num % 10 == 0
        return '"' + TENS[ num / 10 ]
      else
        return TENS[ num / 10 ] + '"' + ONES[ num % 10 ]
      end
    end

    # Is a given Hebrew year a leap year ?
    def self.leap?(year)
      return ((year * 7) + 1).modulo(19) < 7
    end


    # How many months are there in a Hebrew year (12 = normal, 13 = leap)
    def self.year_months(year)
      return leap?(year) ? 13 : 12
    end

    # How many days are in a Hebrew year ?
    def self.year_days(year)
      return to_jd(year + 1, 7, 1) - to_jd(year, 7, 1)
    end

    # How many days are in a given month of a given year
    def self.month_days(year, month)
      # First of all, dispose of fixed-length 29 day months
      case
        when (month == 2 || month == 4 || month == 6 || month == 10 || month == 13)
          return 29

        # If it's not a leap year, Adar has 29 days
        when (month == 12 && !leap?(year)) then
          return 29

        # If it's Cheshvan, days depend on length of year
        when month == 8 && year_days(year).modulo(10) != 5 then
          return 29

        # Similarly, Kislev varies with the length of year
        when (month == 9 && (year_days(year).modulo(10) == 3)) then
          return 29
        
        # Nope, it's a 30 day month
        else
          return 30
      end
    end

    # internal conversion method to keep fields syncronized with julian date
    def convert_from_julian
      dateArray = HebrewDate.jd_to_hebrew(@jd)
      @hy = dateArray[0]		
      @hm = dateArray[1]		
      @hd = dateArray[2]		
    end
    
    # internal conversion method to keep fields syncronized with julian date
    def convert_from_hebrew
      @jd = HebrewDate.to_jd(@hy, @hm, @hd)
    end

    def self.days_in_prior_years(year)
      months_elapsed = (year - 1) / 19 * 235 + # Months in complete cycles so far
        12 * ((year - 1) % 19) + # Regular months in this cycle
        (1 + 7 * ((year -  1) % 19)) / 19 # Leap months in this cycle
      parts_elapsed = 204 +  793 * (months_elapsed % 1080)
      hours_elapsed = 5 +
        12 * months_elapsed +
        793 * ( months_elapsed / 1080) +
        parts_elapsed / 1080
      parts = 1080 * (hours_elapsed % 24) + (parts_elapsed % 1080)
      day = 1 + 29 * months_elapsed + hours_elapsed / 24

      if parts >= 19440 or #If the new moon is at or after midday,
        ( day % 7 == 2 and #...or is on a Tuesday...
          parts >= 9924 and # at 9 hours, 204 parts or later...
          not leap?(year) # of a common year
        ) or
        ( day % 7 == 1 and #...or is on a Monday...
          parts >= 16789 and # at 15 hours, 589 parts or later...
          leap?(year - 1) # at the end of a leap year
        )
      then
        day += 1 #then postpone Rosh HaShanah one day
      end

      #If Rosh HaShanah would occur on Sunday, Wednesday, or Friday
      #Then postpone it one more day
      day += 1 if [0,3,5].include?(day % 7)

      return day + HEBREW_EPOCH + 1
    end

    # Convert hebrew date to julian date
    def self.to_jd(year, month, day)
      months = year_months(year)

      jd = day
      
      if (month < 7) then
        for mon in 7..months
          jd += month_days(year, mon)
        end

        for mon in 1...month
          jd += month_days(year, mon)
        end
      else
        for mon in 7...month
          jd += month_days(year, mon)
        end
      end
      
      jd += days_in_prior_years(year)

      return jd
    end

    # Convert Julian date to Hebrew date
    # This works by making multiple calls to
    # to_jd, and is this very slow
    def self.jd_to_hebrew(jd)
      greg_date = Date.jd(jd)
      month = [nil,9,10,11,12,1,2,3,4,7,7,7,8][greg_date.month]
      day = greg_date.mday
      year = 3760 + greg_date.year

      year += 1 while jd >= to_jd(year + 1, 7, 1) 
      length = year_months(year)
      month = (1 + month % length) while jd > to_jd(year,month,month_days(year,month))

      day = jd - to_jd(year,month,1) + 1

      return [year, month, day]
    end

  end # class

end # module
