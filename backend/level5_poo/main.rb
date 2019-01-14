require 'json'
require "./models.rb"

# Import input
data_hash = JSON.parse(File.read('data/input.json'))

# Split datas
cars = data_hash["cars"]
rentals = data_hash["rentals"]
options = data_hash["options"]

rental_instances = []

# Fill array with instances of Rental
rentals.each do |rental|
  # Create array with options
  options_raw = options.select{ |option| option["rental_id"] == rental["id"] }
  options_array = []
  options_raw.each do |hash|
    options_array << hash["type"]
  end

  # Create instance Car
  car_id = rental["car_id"]
  car = cars.select{ |car| car["id"] == car_id }[0]
  car_instance = Car.new(car["id"], car["price_per_day"], car["price_per_km"])

  # Create instance Rental
  r = Rental.new(rental["id"], car_instance, rental["start_date"], rental["end_date"], rental["distance"], options_array )
  rental_instances << r
end

# Format output
rentals_output = []

rental_instances.each do |rental|
  hash = {"id": rental.id,"options": rental.options, "actions": rental.actions}
  rentals_output << hash
end

output = JSON.pretty_generate({"rentals" => rentals_output})

# Create JSON
File.open("data/output.json","w") do |f|
  f.puts(output)
end
