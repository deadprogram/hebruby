require 'hebruby'

hebrew_date = Hebruby::HebrewDate.new(2, 4, 5728)

puts hebrew_date.day # => 2
puts hebrew_date.month # => 4
puts hebrew_date.month_name # => Tamuz
puts hebrew_date.heb_month_name # => תמוז
puts hebrew_date.year # => 5728
puts hebrew_date.heb_year_name # => התשכ"ח
puts hebrew_date.julian_date  # => 1968-06-28
