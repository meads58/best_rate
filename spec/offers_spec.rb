require 'offers'

describe Offers do

  context 'converting csv to array of hashes' do
    before(:each) do
      @offer = Offers.new
      @test_file = File.dirname(__FILE__) + "/test_offers.csv"
    end
    it 'returns an array' do
      offer_array = @offer.convert_to_array(@test_file)
      expect(offer_array.class).to eq Array
    end

    it "will have return all rows in the csv as an array of hashes" do
      offer_array = @offer.convert_to_array(@test_file)
      expect(offer_array).to contain_exactly({lender: 'Bob', rate: 0.05, avaliable: 500}, {rate: 0.9, lender: 'Jill', avaliable: 200})
    end
  end

end