class Person
  attr_accessor :name, :age, :weight

  def initialize(options={})
    self.name = options[:name]
    self.age = options[:age]
    self.weight = options[:weight].to_f
  end
end
