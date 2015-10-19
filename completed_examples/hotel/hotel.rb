class Hotel
  attr_reader :name

  def initialize(name, options={})
    @name = name
    @rooms = []

    # hmmm... maybe there's a code-smell here? some repetition, with only the size of the room being the difference
    options[:doubles].to_i.times do
      @rooms << Room.new(2)
    end

    options[:singles].to_i.times do
      @rooms << Room.new(1)
    end
  end

  def capacity
    @rooms.map(&:capacity).inject(:+)
  end

  def vacancies
    @rooms.inject(0) { |sum, room| room.vacant? ? sum + room.capacity : sum }
  end

  def check_in(*guests)
    guests.flatten!
    if guests.size > vacancies
      "There are not enough vacancies for that amount of guests. You need #{guests.size} beds, and #{name} only has #{vacancies} vacancies"
    else
      while guests.any? do
        room = @rooms.detect(&:vacant?)
        room.capacity.times { room.add(guests.shift) if guests.any? }
      end
      "checked in!"
    end
  end

  def guest_list
    @rooms.each_with_index.map { |room, index| "Room #{index+1} is a #{room.room_type} occupied by: #{room.guest_list.join(', ')}." if room.occupied? }.compact
  end

  def pretty_string
    "'#{name}' has a capacity of #{capacity}, with #{vacancies} vacancies at the moment."
  end

  def revenue
    @rooms.inject(0) { |memo, room| memo + room.revenue}
  end

  def vacate_room(room_index)
    if room = @rooms[room_index]
      leavers = room.vacate
      "room vacated by: #{leavers.map(&:name).join(', ')}" if leavers.any?
    else
      "unknown room"
    end
  end
end


