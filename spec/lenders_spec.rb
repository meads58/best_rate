require 'lenders'

describe Lender do
  let(:lender) {Lender.new}

  context 'converting csv to array of hashes' do
    before(:each) do
      @test_file = File.dirname(__FILE__) + "/test_offers.csv"
    end
    it 'returns an array' do
      lender_array = lender.convert_csv_to_array(@test_file)
      expect(lender_array.class).to eq Array
    end

    it "will have return all rows in the csv as an array of hashes" do
      lender_array = lender.convert_csv_to_array(@test_file)
      expect(lender_array).to contain_exactly({lender: 'Bob', rate: 0.05, available: 500}, {rate: 0.9, lender: 'Jill', available: 200})
    end
  end

  context 'sorting lenders' do
    before(:each) do
      @lender_list = [{lender: 'Bob', rate: 0.95, avaliable: 500}, {rate: 0.09, lender: 'Jill', avaliable: 200}]
    end
    it 'will sort the lenders list in ascending order by rate' do
      expect(lender.sort_rates @lender_list).to be == [{rate: 0.09, lender: 'Jill', avaliable: 200},{lender: 'Bob', rate: 0.95, avaliable: 500}]
    end
  end

end