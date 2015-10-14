class Building
  attr_accessor :name, :postcode, :floors
  attr_reader :lifts

  def initialize(options={})
    self.name = options[:name]
    self.postcode = options[:postcode]
    self.floors = options[:floors] || 1
    @lifts = options[:lifts].times.map { Lift.new }
  end

  def capacity
    memo = { max_passengers: 0, current_passengers: 0 }
    lifts.reduce(memo) do |memo, lift|
      memo[:max_passengers] += lift.max_passengers
      memo[:current_passengers] += lift.passengers.count
      memo
    end
  end
end
