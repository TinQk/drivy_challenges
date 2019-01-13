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

  rental_price = price_per_day * duration + price_per_km * distance
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
