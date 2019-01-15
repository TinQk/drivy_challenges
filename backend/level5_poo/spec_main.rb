### INTEGRATION TESTING

require 'rspec'
require_relative 'main'

# Compare output to expected_output

RSpec.describe "Rentals'actions" do

  describe 'Create JSON' do
    it 'creates the correct file' do
      output = JSON.parse(File.read('data/output.json'))
      expected_output = JSON.parse(File.read('data/expected_output.json'))
      expect(output).to eql(expected_output)
    end
  end

end
