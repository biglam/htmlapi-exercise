def menu
  puts `clear`
  puts "*** Hotel Chain -- an original name (TM) ***\n\n"

  puts "1 : List Hotels"
  puts "2 : Check In"
  puts "3 : Vacate Room"
  puts "4 : Occupancy Report"
  puts "5 : Revenue Report"
  puts
  puts "0 : Quit\n\n"
  print "--> "
  gets.to_i
end

def list_hotels(chain)
  puts chain.list_hotels
end

def check_in(chain)
  guests = []
  print "Enter guest name: "
  while guest_name = gets.chomp
    break if guest_name.empty?
    guests << Visitor.new(guest_name)
    print "Enter next guest name (or press enter to choose hotel): "
  end

  puts "The following hotels have space for your guests:"
  puts chain.list_hotels_with_space_for_guests(guests.size)

  print "Please enter the name of the hotel you want to check-in to: "
  hotel_name = gets.chomp

  if hotel = chain.get_hotel(hotel_name)
    puts hotel.check_in(guests)
  else
    puts "Can't seem to find a hotel with that name."
  end
end

def vacate_room(chain)
  puts chain.list_hotels

  print "Please enter the name of the hotel you want vacate a room of: "
  hotel_name = gets.chomp

  if hotel = chain.get_hotel(hotel_name)
    guest_list = hotel.guest_list
    if guest_list.any?
      puts "These are the occupied rooms:"
      puts guest_list.join("\n")
      print "which room do you wish to vacate?: "
      room_number = gets.to_i - 1
      puts hotel.vacate_room(room_number) || "That room was vacant already."
    else
      puts "There are no guests in that hotel."
    end

  else
    puts "Can't seem to find a hotel with that name."
  end
end

def occupancy_report(chain)
  chain.hotels.each do |hotel|
    puts "Hotel: #{hotel.pretty_string}"
    puts hotel.guest_list
    puts
  end
end

def revenue_report(chain)
  chain.hotels.each do |hotel|
    puts "Hotel: #{hotel.pretty_string}"
    puts "Today's revenue is £#{hotel.revenue}"
    puts
  end
end
