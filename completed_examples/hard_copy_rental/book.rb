class Book
  attr_reader :name, :topic

  def initialize(options={})
    @name = options[:name]
    @topic = options[:topic]
  end

  def pretty_string
    "Book ID #{object_id} is called '#{name}' and is a #{topic} book"
  end

end