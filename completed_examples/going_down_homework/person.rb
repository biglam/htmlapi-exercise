class Person
  attr_accessor :name, :age, :weight, :floor, :destination

  def initialize(options={})
    self.name = options[:name]
    self.age = options[:age]
    self.weight = options[:weight]
    self.floor = 0
    self.destination = options.fetch(:destination, 0)
  end

end
