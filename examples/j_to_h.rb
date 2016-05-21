require 'hebruby'
require 'date'

julian_date = Date.new(2010, 1, 1)
hebrew_date = Hebruby::HebrewDate.new(julian_date)

puts hebrew_date.day # => 15
puts hebrew_date.month # => 10
puts hebrew_date.month_name # => "Tevet"
puts hebrew_date.heb_month_name # => טבת
puts hebrew_date.year # => 5770
puts hebrew_date.heb_year_name # => התש"ע
