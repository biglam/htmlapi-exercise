require 'pry-byebug'

require_relative 'library'
require_relative 'book'
require_relative 'person'
require_relative 'methods'

library = Library.new 'Code Clan Library'

library.add_person(Person.new('Fred'))
library.add_person(Person.new('Wilma'))
library.add_person(Person.new('Barney'))
library.add_person(Person.new('Betty'))
library.add_book(Book.new(name: "The Hobbit", topic: "Fantasy"))
library.add_book(Book.new(name: "Feersum Endjinn", topic: "Science Fiction"))
library.add_book(Book.new(name: "Histories", topic: "History"))
library.add_book(Book.new(name: "To Kill a Mockingbird", topic: "Fiction"))
library.add_book(Book.new(name: "A Brief History of Time", topic: "Non-Fiction"))

response = menu
while response != 0

  case response
    when 1
      create_book(library)
    when 2
      create_person(library)
    when 3
      list_books(library)
    when 4
      list_people(library)
    when 5
      lend_book(library)
    when 6
      return_book(library)
    when 7
      list_borrowed_books(library)
    else
      puts "invalid option"
  end

  puts "press enter to continue"
  gets

  response = menu
end

binding.pry;''