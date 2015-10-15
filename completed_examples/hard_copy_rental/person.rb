class Person
  attr_reader :name, :books

  def initialize(name)
    @name = name
    @books = {}
  end

  def borrow(book)
    @books[book.object_id.to_s] = book
  end

  def return(book_key)
    @books.delete(book_key)
  end

  def list_books
    if books.empty?
      "'#{name}'' has no books at the moment"
    else
      books.map do |key, book|
        book.pretty_string
      end.join("\n")
    end
  end

  def pretty_string
    "Person ID #{object_id} is called '#{name}' and has #{books.size} book#{'s' unless books.size == 1} borrowed at the moment."
  end
end