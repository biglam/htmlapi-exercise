class Lift
  attr_accessor :floor
  attr_reader :max_weight, :max_passengers, :passengers

  def initialize
    self.floor = 0
    @max_weight = 800 # KGs
    @max_passengers = 8
    @passengers = []
  end

  def enter(passenger)
    passengers << passenger unless exceeds_capacity(passenger)
  end

  def distance_to_floor(floor)
    (self.floor - floor).abs
  end

  def travel_to!(floor)
    passengers.each { |passenger| passenger.floor = floor }
    self.floor = floor.to_i
  end

  def leave(passenger)
    passenger_index = passengers.index(passenger)
    passengers.delete_at(passenger_index) if passenger_index
  end

  def exceeds_capacity(passenger)
    too_many_passengers? || weight_limit_exceeded?(passenger)
  end

  def too_many_passengers?
    passengers.count >= max_passengers
  end

  def weight_limit_exceeded?(passenger)
    (passengers.reduce(0) { |sum, p| sum + p.weight } + passenger.weight) > max_weight
  end

end