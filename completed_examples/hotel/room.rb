class Room
  attr_reader :capacity

  def initialize(capacity)
    @people = []
    @capacity = capacity.to_i
  end

  def occupied?
    @people.any? || capacity < 1
  end

  def vacant?
    !occupied?
  end

  def add(guest)
    @people << guest
  end

  def vacate
    @people.size.times.map { @people.pop }
  end

  def room_type
    case capacity
    when 1 then "Single"
    when 2 then "Double"
    else "Cupboard"
    end
  end

  def guest_list
    @people.map { |person| person.pretty_string }
  end

  def revenue
    if occupied?
      case room_type
      when "Single" then 100
      when "Double"
        @people.size == 1 ? 150 : 200
      end
    end.to_f
  end
end
