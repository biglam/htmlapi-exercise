
def journey_length(tram_line, start_station, end_station)
  start_station_index = lothian_trams[tram_line].index(start_station)
  end_station_index = lothian_trams[tram_line].index(end_station)
  (start_station_index - end_station_index).abs
end

def lothian_trams
  {
    one: ['Airport', 'Gyle Centre', 'Edinburgh Park', 'Murrayfield Stadium', 'Haymarket', 'Princes Street', 'York Place'],
    two: ['Saltire Square', 'West Pilton', 'Telford Road', 'Craigleith', 'Haymarket'],
    three: ['Gallery of Modern Art', 'Haymarket', 'EICC', 'Bread Street', 'Tollcross', 'The Meadows']
  }
end

puts `clear`
puts "*** Lothian Trams ***"

print "\nWhat tram are you getting on: #{lothian_trams.keys.join(', ')}? "
start_tram = gets.chomp.to_sym
print "Which stop on the #{start_tram} tram: #{lothian_trams[start_tram].join(', ')}? "
start_station = gets.chomp

print "\nWhat tram are you getting off: #{lothian_trams.keys.join(', ')}? "
end_tram = gets.chomp.to_sym
print "Which stop on the #{end_tram} tram: #{lothian_trams[end_tram].join(', ')}? "
end_station = gets.chomp

if start_tram == end_tram
  total_length_of_trip = journey_length(start_tram, start_station, end_station)
else
  intersection = (lothian_trams[start_tram] & lothian_trams[end_tram]).first
  first_leg_length = journey_length(start_tram, start_station, intersection)
  second_leg_length = journey_length(end_tram, intersection, end_station)

  total_length_of_trip = first_leg_length + second_leg_length
end

puts "\n\nYour trip length is #{total_length_of_trip} stops.\n\n"
