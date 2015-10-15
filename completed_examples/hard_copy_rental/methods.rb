def menu
  puts `clear`
  puts "*** Hard Copy Rental -- CodeClanLibrary ***\n\n"

  puts "1 : Create Book"
  puts "2 : Create Person"
  puts "3 : List Books"
  puts "4 : List People"
  puts "5 : Lend Book"
  puts "6 : Return Book"
  puts "7 : List Borrowed Books"
  puts
  puts "0 : Quit\n\n"
  print "--> "
  gets.to_i
end

def list_books(library)
  puts library.list_books
end

def list_people(library)
  puts library.list_people
end

def create_person(library)
  print "Name: "
  name = gets.chomp

  library.add_person(Person.new(name))
end

def create_book(library)
  print "Name: "
  name = gets.chomp

  print "Topic: "
  topic = gets.chomp

  library.add_book(Book.new(name: name, topic: topic))
end

def lend_book(library)
  puts library.list_books
  puts
  print "Which book do you want to lend (by ID): "
  book_key = gets.chomp

  puts
  puts library.list_people
  puts
  print "Which person is going to borrow it (by ID): "
  person_key = gets.chomp

  puts library.lend(person_key, book_key)
end

def return_book(library)
  puts
  puts library.list_people
  puts
  print "Which person is returning a book (by id): "
  person_key = gets.chomp

  if person = library.people[person_key]
    puts person.list_books
    puts
    print "Which book are they returning (by id): "
    book_key = gets.chomp

    puts library.return(person_key, book_key)
  else
    puts "Invalid person name"
  end
end

def list_borrowed_books(library)
  puts library.list_borrowed_books
end
