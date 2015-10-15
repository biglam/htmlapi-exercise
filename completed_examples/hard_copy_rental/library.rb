class Library
  attr_reader :name, :books, :people

  def initialize(name)
    @name = name
    @books = {}
    @people = {}
  end

  def list_books
    if books.empty?
      "There are no books in the library at the moment"
    else
      books.map do |key, book|
        book.pretty_string
      end.join("\n")
    end
  end

  def list_people
    if people.empty?
      "There are no people in the library at the moment"
    else
      people.map do |key, person|
        person.pretty_string
      end.join("\n")
    end
  end

  def list_borrowed_books
    people.reduce('') do |memo, (key, person)|
      if person.books.any?
        memo += ("#{person.name} has the following books:\n" + person.list_books)
      end
      memo
    end.tap { |s| s.replace("There are no borrowed books at the moment") if s.empty? }

  end

  def add_book(book)
    @books[book.object_id.to_s] = book
  end

  def add_person(person)
    @people[person.object_id.to_s] = person
  end

  def lend(person_key, book_key)
    if person = people[person_key]
      if book = @books.delete(book_key)
        person.borrow(book)
        return nil
      else
        "Invalid book name"
      end
    else
      "Invalid person name"
    end
  end

  def return(person_key, book_key)
    if person = people[person_key]
      if @books[book_key] = person.return(book_key)
        return nil
      else
        "Invalid book name"
      end
    else
      "Invalid person name"
    end
  end


end