class Chain
  attr_reader :hotels

  def initialize
    @hotels = []
  end

  def add_hotel(hotel)
    @hotels << hotel
  end

  def list_hotels(hotels=self.hotels)
    if hotels.empty?
      "There are no hotels in the chain at the moment"
    else
      hotels.map do |hotel|
        hotel.pretty_string
      end.join("\n")
    end
  end

  def list_hotels_with_space_for_guests(amount_of_guests)
    list_hotels(hotels.select { |hotel| hotel.vacancies >= amount_of_guests })
  end

  def get_hotel(hotel_name)
    hotels.detect { |hotel| hotel.name == hotel_name }
  end

end