require 'matcher'

describe Matcher do
	let(:match) {Matcher.new}

	context 'Lender amount greater than borrower amount' do
    before(:each) do
      @lender_list = [{lender: 'Bob', rate: 0.05, avaliable: 500}]
      @borrower_amount = 400
    end
		it 'will return true if the full borrow amount can be matched' do
      expect(match.match?(@lender_list, @borrower_amount)).to be true
		end
	end

end