require 'matcher'

describe Matcher do
	let(:match) {Matcher.new}
  before(:each) do
    @lender_list = [{lender: 'Bob', rate: 0.05, avaliable: 300},{lender: 'Jill', rate: 0.15, avaliable: 200}]  
    @valid_borrower_amount = 300
    @invalid_borrower_amount = 700
  end

	context 'Lender amount greater than borrower amount' do
 		it 'will return true if the borrow amount is less than all lenders total' do
      borrower_amount = 499
      expect(match.enough_funds?(@lender_list, borrower_amount)).to be true
		end
    it 'will return true if the borrow amount euqals the avaliable lenders total' do
      equal_borrower = 500
      expect(match.enough_funds?(@lender_list, equal_borrower)).to be true
    end
    it 'will return false if the full borrow amount is greater than with the lenders total' do
      greater_borrower = 501
      expect(match.enough_funds?(@lender_list, greater_borrower)).to be false
    end
	end

  context 'available_lender_amount' do
    it 'can find the total availiale amount for all lenders' do
      expect(match.available_lender_amount @lender_list).to eq 500
    end
  end

  context 'match_amount' do
    it 'will call caluclate_rate if there are enough avaliable funds to lend out' do
      expect(match).to receive(:calculate_rate)
      match.match_amount(@lender_list, @valid_borrower_amount)
    end

    it "returns the message 'Cannot caclulate you request as there are not enough funds to match your request at the present time' if the full borrower amount is not matched" do
      expect(match.match_amount(@lender_list, @invalid_borrower_amount)).to eq 'Cannot caclulate you request as there are not enough funds to match your request at the present time'
    end
  end

  context 'calc_lent_amount' do
    it 'returns the lenders amount when less then remaining amount to borrow' do
      lender_amount = 100
      remaining_to_borrow = 300
      expect(match.calc_lent_amount(lender_amount, remaining_to_borrow)).to eq 100
    end
     it 'returns the borrowers amount when greater then the lenders amount' do
      lender_amount = 400
      remaining_to_borrow = 200
      expect(match.calc_lent_amount(lender_amount, remaining_to_borrow)).to eq 200
    end

    it 'returns the borrowers amount when equal the lenders amount' do
      lender_amount = 400
      remaining_to_borrow = 400
      expect(match.calc_lent_amount(lender_amount, remaining_to_borrow)).to eq 400
    end
  end

end