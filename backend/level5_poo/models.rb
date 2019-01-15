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
  attr_accessor :id
  attr_accessor :car_id
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :distance
  attr_accessor :options # Array with options "type"

  def initialize(id, car, start_date, end_date, distance, options = [])
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @options = options

    @price_gps = 0
    @price_baby_seat = 0
    @price_additional_insurance = 0

    options.each do |option|
      case option
        when "gps" then @price_gps = 500 * duration
        when "baby_seat" then @price_baby_seat = 200 * duration
        when "additional_insurance" then @price_additional_insurance = 1000 * duration
      end
    end
  end

  # Return number of days
  def duration
    start_date = DateTime.parse(@start_date)
    end_date = DateTime.parse(@end_date)
    (end_date - start_date).to_i + 1
  end

  def duration_price
    case duration
      when 1 then @car.price_per_day
      when 2..4 then @car.price_per_day + @car.price_per_day * (duration - 1) * 90 / 100
      when 5..10 then @car.price_per_day + @car.price_per_day * 3 * 90 / 100 + @car.price_per_day * (duration - 4) * 70 / 100
      else @car.price_per_day + @car.price_per_day * 3 * 90 / 100 + @car.price_per_day * 6 * 70 / 100 + @car.price_per_day * (duration - 10) * 50 / 100
    end
  end

  def price_without_options
    duration_price + @car.price_per_km * @distance
  end

  def price_with_options
    price_without_options + @price_gps + @price_baby_seat + @price_additional_insurance
  end

# Return a hash including financial actions to do
  def actions
    com = (price_without_options * 30 / 100).to_i
    insurance_fee = (com / 2).to_i
    assistance_fee = duration * 100
    drivy_fee = com - insurance_fee - assistance_fee

    debit_driver = {"who": "driver", "type": "debit", "amount": price_with_options}
    credit_owner = {"who": "owner", "type": "credit", "amount": price_without_options * 70 / 100 + @price_gps + @price_baby_seat }
    credit_insurance = {"who": "insurance", "type": "credit", "amount": insurance_fee}
    credit_assistance = {"who": "assistance", "type": "credit", "amount": assistance_fee}
    credit_drivy = {"who": "drivy", "type": "credit", "amount": drivy_fee + @price_additional_insurance}

    actions = [debit_driver, credit_owner, credit_insurance, credit_assistance, credit_drivy]
  end
end
