require "pry-byebug"

require_relative "chain"
require_relative "hotel"
require_relative "room"
require_relative "visitor"
require_relative "methods"

# set up a chain of hotels to manage
bad_house = Chain.new

# create a couple of hotels and add them to the chain
hotel_california = Hotel.new('California', doubles: 3, singles: 2)
hotel_of_wine = Hotel.new('Winey', doubles: 6, singles: 7)
hotel_chocolate = Hotel.new('Chocolatey', doubles: 3, singles: 6)
bad_house.add_hotel hotel_california
bad_house.add_hotel hotel_of_wine
bad_house.add_hotel hotel_chocolate

# seed the hotels with a few initial checkins
hotel_chocolate.check_in Visitor.new("tim")
hotel_california.check_in Visitor.new("max"), Visitor.new("clements")
hotel_of_wine.check_in Visitor.new("nico")
hotel_of_wine.check_in Visitor.new("luke")
hotel_of_wine.check_in Visitor.new("carrie")


# get on with the bones of running the app
response = menu
while response != 0

  case response
    when 1
      list_hotels(bad_house)
    when 2
      check_in(bad_house)
    when 3
      vacate_room(bad_house)
    when 4
      occupancy_report(bad_house)
    when 5
      revenue_report(bad_house)
    else
      puts "invalid option"
  end

  puts "press enter to continue"
  gets

  response = menu
end

binding.pry;''
