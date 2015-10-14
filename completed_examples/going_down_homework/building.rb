class Building
  attr_accessor :name, :postcode, :floors
  attr_reader :lifts, :occupants

  def initialize(options={})
    self.name = options[:name]
    self.postcode = options[:postcode]
    self.floors = options[:floors] || 1
    @lifts = options[:lifts].to_i.times.map { Lift.new }
    @occupants = []
  end

  def catch_lift(person)
    if occupants.include?(person)
      lift = call_lift(person.floor)
      if lift.enter(person)
        vacated_by(person)
        lift
      end
    end
  end

  def exit_lifts
    lifts.each do |lift|
      lift.passengers.each do |passenger|
        if passenger.destination == lift.floor
          lift.leave(passenger)
          passenger.floor = lift.floor
          entered_by(passenger)
        end
      end
    end
  end

  def call_lift(floor)
    closest_lift = lifts.reduce { |memo, lift| memo.distance_to_floor(floor) > lift.distance_to_floor(floor) ? lift : memo}
    closest_lift.travel_to!(floor)
    closest_lift
  end

  def entered_by(person)
    @occupants << person unless @occupants.include?(person)
  end

  def vacated_by(person)
    @occupants.delete(person)
  end

  def capacity
    memo = { max_passengers: 0, max_weight: 0, current: { passengers: 0, weight: 0 } }
    lifts.reduce(memo) do |memo, lift|
      memo[:max_passengers] += lift.max_passengers
      memo[:max_weight] += lift.max_weight
      memo[:current][:passengers] += lift.passengers.count
      memo[:current][:weight] += lift.passengers.reduce(0) { |sum, p| sum + p.weight }
      memo
    end
  end
end
