class Lift
  attr_accessor :floor
  attr_reader :max_passengers, :passengers

  def initialize
    self.floor = 0
    @max_passengers = 8
    @passengers = []
  end

  def enter(passenger)
    passengers << passenger unless exceeds_capacity(passenger)
  end

  def exceeds_capacity(passenger)
    passengers.count >= max_passengers
  end

end