require 'json'
require 'time'

# Import input
data_hash = JSON.parse(File.read('data/input.json'))

# Split datas
@cars = data_hash["cars"]
@rentals = data_hash["rentals"]

# Rental price = price_per_day * duration + price_per_km * distance
def price(rental)
  car_id = rental["car_id"]
  car = @cars.select{ |car| car["id"] == car_id }[0]

  price_per_day = car["price_per_day"]
  price_per_km = car["price_per_km"]

  start_date = DateTime.parse(rental["start_date"])
  end_date = DateTime.parse(rental["end_date"])
  duration = (end_date - start_date).to_i + 1

  distance = rental["distance"]

  # price per day discount : 10% after 1 day, 30% after 4 days, 50% after 10 days
  duration_price =  if duration == 1
                      price_per_day
                    elsif duration > 1 && duration < 5
                      price_per_day + price_per_day * (duration - 1) * 90 / 100
                    elsif duration > 4 && duration < 11
                      price_per_day + price_per_day * 3 * 90 / 100 + price_per_day * (duration - 4) * 70 / 100
                    else
                      price_per_day + price_per_day * 3 * 90 / 100 + price_per_day * 6 * 70 / 100 + price_per_day * (duration - 10) * 50 / 100
                    end

  rental_price = duration_price + price_per_km * distance
end

# Return a hash including financial actions to do
def actions(rental)
  tot_com = price(rental) * 30 / 100
  start_date = DateTime.parse(rental["start_date"])
  end_date = DateTime.parse(rental["end_date"])
  duration = (end_date - start_date).to_i + 1
  insurance_fee = tot_com / 2 .to_i
  assistance_fee = duration * 100
  drivy_fee = tot_com - insurance_fee - assistance_fee

  debit_driver = {"who": "driver", "type": "debit", "amount": price(rental)}
  credit_owner = {"who": "owner", "type": "credit", "amount": (price(rental) - tot_com)}
  credit_insurance = {"who": "insurance", "type": "credit", "amount": insurance_fee}
  credit_assistance = {"who": "assistance", "type": "credit", "amount": assistance_fee}
  credit_drivy = {"who": "drivy", "type": "credit", "amount": drivy_fee}

  actions = [debit_driver, credit_owner, credit_insurance, credit_assistance, credit_drivy]
end


# Format output
rentals_output = []

@rentals.each do |rental|
  hash = {"id": rental["id"], "actions": actions(rental)}
  rentals_output << hash
end

output = JSON.pretty_generate({"rentals" => rentals_output})

# Create JSON
File.open("data/output.json","w") do |f|
  f.puts(output)
end
