### UNIT TESTING

require 'rspec'
require_relative 'models'

RSpec.describe Rental do
  car = Car.new(1, 1000, 200)
  subject {Rental.new(1, car, "2015-12-8", "2015-12-12", 200, ["gps"]) }

  describe '#duration' do
    it 'returns duration of rental' do
      expect(subject.duration).to eql(5)
    end
  end

  describe '#duration_price' do
    it 'return duration_price of rental' do
      expect(subject.duration_price).to eql(4400)
    end
  end

  describe '#price_without_options' do
    it 'return price_without_options' do
      expect(subject.price_without_options).to eql(44400)
    end
  end

  describe '#price_with_options' do
    it 'return price_with_options' do
      expect(subject.price_with_options).to eql(46900)
    end
  end
end
