require 'pry-byebug'

require_relative 'building'
require_relative 'lift'
require_relative 'person'

b = Building.new name: 'Megadodo Publications', postcode: 'W1N 4HR', floors: 57, lifts: 4

arthur = Person.new(name: 'Arthur', age: 42, weight: 100)

b.lifts.first.enter(arthur)


binding.pry;''
