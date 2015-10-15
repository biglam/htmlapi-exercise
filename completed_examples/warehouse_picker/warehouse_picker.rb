require 'pry-byebug'

BAYS = ['a10', 'a9', 'a8', 'a7', 'a6', 'a5', 'a4', 'a3', 'a2', 'a1', 'c1', 'c2', 'c3', 'c4', 'c5', 'c6', 'c7', 'c8', 'c9', 'c10', 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7', 'b8', 'b9', 'b10']

PRODUCTS = [
  {bay: 'a10', name: "rubber band"},
  {bay: 'a9', name: "glowstick"},
  {bay: 'a8', name: "model car"},
  {bay: 'a7', name: "bookmark"},
  {bay: 'a6', name: "shovel"},
  {bay: 'a5', name: "rubberduck"},
  {bay: 'a4', name: "hanger"},
  {bay: 'a3', name: "blouse"},
  {bay: 'a2', name: "stop sign"},
  {bay: 'a1', name: "needle"},
  {bay: 'c1', name: "rusty nail"},
  {bay: 'c2', name: "drill press"},
  {bay: 'c3', name: "chalk"},
  {bay: 'c4', name: "wordsearch"},
  {bay: 'c5', name: "thermometer"},
  {bay: 'c6', name: "face wash"},
  {bay: 'c7', name: "paint brush"},
  {bay: 'c8', name: "candy wrapper"},
  {bay: 'c9', name: "shoe lace"},
  {bay: 'c10', name: "leg warmers"},
  {bay: 'b1', name: "tyre swing"},
  {bay: 'b2', name: "sharpie"},
  {bay: 'b3', name: "picture frame"},
  {bay: 'b4', name: "photo album"},
  {bay: 'b5', name: "nail filer"},
  {bay: 'b6', name: "tooth paste"},
  {bay: 'b7', name: "bath fizzers"},
  {bay: 'b8', name: "tissue box"},
  {bay: 'b9', name: "deodorant"},
  {bay: 'b10', name: "cookie jar"}
]

def bay_choice
  puts "Enter your bays, seperated by commas (eg: a1, b2, c3)"
  bays = gets.chomp.split(/,\s?/)

  items = PRODUCTS.select { |product| bays.include?(product[:bay]) }
  item_names = items.map { |item| item[:name] }

  min_index, max_index = bays.map { |bay| BAYS.index(bay) }.minmax
  distance = max_index - min_index

  puts "The products are: #{item_names.join(', ')}, and they're #{distance} bays apart"
end

def product_choice
  puts "Enter your products, seperated by commas (eg: knife, tv, ice cream)"
  items = gets.chomp.split(/,\s?/).sort

  items = PRODUCTS.select { |item| items.include?(item[:name]) }
  indexes = items.map { |item| BAYS.index(item[:bay]) }.sort

  sorted_bays = indexes.map { |index| BAYS[index] }
  puts "Those items need to be collected from #{sorted_bays.join(', ')}"
end

puts `clear`
puts "*** Warehouse Picker ***"

print "\nDo you want to search (b)ays or (p)roducts : ? "
choice = gets.chomp

case choice
  when 'b'
    bay_choice
  when 'p'
    product_choice
  else
    puts "sorry, I don't recognise that choice."
end
