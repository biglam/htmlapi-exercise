class Visitor
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def pretty_string
    @name
  end
end

