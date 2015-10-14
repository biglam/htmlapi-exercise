require 'pry-byebug'

require_relative 'building'
require_relative 'lift'
require_relative 'person'

b = Building.new name: 'Megadodo Publications', postcode: 'W1N 4HR', floors: 57, lifts: 4

arthur          = Person.new(name: 'Arthur', age: 42, weight: 100, destination: 31)
trillian        = Person.new(name: 'Trillian', age: 27, weight: 65, destination: 18)
ford            = Person.new(name: 'Ford', age: 78, weight: 88, destination: 6)
zaphod          = Person.new(name: 'Zaphod', age: 109, weight: 120, destination: 46)
marvin          = Person.new(name: 'Marvin', age: 300000000078, weight: 220)
slartibartfast  = Person.new(name: 'Slartibartfast', age: 76, weight: 67)
prosser         = Person.new(name: 'Mr. Prosser', age: 49, weight: 110)
jeltz           = Person.new(name: 'Jeltz', age: 543, weight: 435)
fenchurch       = Person.new(name: 'Fenchurch', age: 32, weight: 66)

[arthur, trillian, ford, zaphod, marvin, slartibartfast, prosser, jeltz, fenchurch].each { |person| b.entered_by(person) }

b.catch_lift arthur
b.catch_lift trillian
b.catch_lift ford

b.lifts.first.travel_to! 6

b.catch_lift zaphod


binding.pry;''

# b.exit_lifts
# b.lifts.first.travel_to! 18
# b.lifts[1].travel_to! 40
# ford.destination = 9
# b.catch_lift ford

