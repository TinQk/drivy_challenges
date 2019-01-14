require 'time'

class Car
  attr_reader :id
  attr_accessor :price_per_day
  attr_accessor :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end

class Rental
  attr_reader :id
  attr_accessor :car
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :distance

  def initialize(id, car, start_date, end_date, distance)
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  # Return number of days
  def duration
    start_date = DateTime.parse(@start_date)
    end_date = DateTime.parse(@end_date)
    (end_date - start_date).to_i + 1
  end

  def duration_price
    price = case duration
      when 1 then @car.price_per_day
      when 2..4 then @car.price_per_day + @car.price_per_day * (duration - 1) * 90 / 100
      when 5..10 then @car.price_per_day + @car.price_per_day * 3 * 90 / 100 + @car.price_per_day * (duration - 4) * 70 / 100
      else @car.price_per_day + @car.price_per_day * 4 * 90 / 100 + @car.price_per_day * 6 * 70 / 100 + @car.price_per_day * (duration - 10) * 50 / 100
    end
  end

  def price_without_options

  end

  def price_with_options
  end

  def actions
  end
end

v = Car.new(1, 2000, 100)

r = Rental.new(1, v, "2015-12-1", "2015-12-8", 100)

puts r.duration
puts r.duration_price
