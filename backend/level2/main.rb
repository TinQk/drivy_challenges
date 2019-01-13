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

# Format output
rentals_output = []

@rentals.each do |rental|
  hash = {"id": rental["id"], "price": price(rental)}
  rentals_output << hash
end

output = JSON[{"rentals" => rentals_output}]

# Create JSON
File.open("data/output.json","w") do |f|
  f.puts(output)
end
