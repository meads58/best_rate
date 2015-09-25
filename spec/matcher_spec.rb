require 'matcher'

describe Matcher do
	let(:match) {Matcher.new}
  before(:each) do
    @sorted_lender_list = [{lender: 'Bob', rate: 0.05, available: 300},{lender: 'Jill', rate: 0.15, available: 200}]  
    @valid_borrower_amount = 300
    @invalid_borrower_amount = 700
    match.sorted_lenders = @sorted_lender_list
    match.borrow_amount = @valid_borrower_amount
  end

	context 'enough_funds?' do
 		it 'will return true if the borrow amount is less than all lenders total' do
      borrower_amount = 499
      match.borrow_amount = borrower_amount
      allow(match).to receive(:total_lenders_amount).and_return(500)
      expect(match.enough_funds?).to be true
		end
    it 'will return true if the borrow amount euqals the avaliable lenders total' do
      equal_borrower = 500
      match.borrow_amount = equal_borrower
      allow(match).to receive(:total_lenders_amount).and_return(500)
      expect(match.enough_funds?).to be true
    end
    it 'will return false if the full borrow amount is greater than with the lenders total' do
      greater_borrower = 501
      match.borrow_amount = greater_borrower
      allow(match).to receive(:total_lenders_amount).and_return(500)
      expect(match.enough_funds?).to be false
    end
	end

  context 'total_lenders_amount' do
    it 'can find the total availiale amount for all lenders' do
      expect(match.total_lenders_amount).to eq 500
    end
  end

  context 'run_matcher' do
    it 'will call caluclate_rate if there are enough avaliable funds to lend out' do
      expect(match).to receive(:calculate_rate)
      match.run_matcher(@sorted_lender_list, @valid_borrower_amount)
    end

    it "returns the message 'Cannot caclulate your request as there are not enough funds to match your request at the present time' if the full borrower amount is not matched" do
      expect(match.run_matcher(@sorted_lender_list, @invalid_borrower_amount)).to eq 'Cannot caclulate your request as there are not enough funds to match your request at the present time'
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

  context 'matched_lenders' do
    it 'given a sorted lender list it returns an array with the amount matched per lender to the borrower amount' do
      match.borrow_amount = 400
      expect(match.matched_lenders).to be == [{lender: 'Bob', rate: 0.05, available: 300, lent_amount: 300},{lender: 'Jill', rate: 0.15, available: 200, lent_amount: 100}] 
    end

    it 'sets all lenders that are not matched to a lent_amount of 0' do
      match.borrow_amount = 400
      match.sorted_lenders = [{lender: 'Bob', rate: 0.05, available: 300},{lender: 'Jill', rate: 0.15, available: 200}, {lender: 'Ian', rate: 0.35, available: 300}, {lender: 'Kim', rate: 0.45, available: 200}]
      expect(match.matched_lenders).to be == [{lender: 'Bob', rate: 0.05, available: 300, lent_amount: 300},{lender: 'Jill', rate: 0.15, available: 200, lent_amount: 100}, {lender: 'Ian', rate: 0.35, available: 300, lent_amount: 0}, {lender: 'Kim', rate: 0.45, available: 200, lent_amount: 0}]
    end
  end

  context 'weighted_interest' do
    before(:each) do
      @matched_lenders = [{lender: 'Bob', rate: 0.05, available: 300, lent_amount: 300},{lender: 'Jill', rate: 0.15, available: 200, lent_amount: 100}, {lender: 'Jill', rate: 0.15, available: 200, lent_amount: 0}]
    end
    it 'can if the weighted interest rate from all the matched lenders' do
      expect(match.weighted_interest(@matched_lenders)).to eq 0.075
    end
  end

  context 'calculate_rate' do
    it 'calls the matched_lenders method' do
      allow(match).to receive(:weighted_interest)
      expect(match).to receive(:matched_lenders)
      match.calculate_rate
    end
     it 'calls the weighted_interest method' do
      allow(match).to receive(:matched_lenders)
      expect(match).to receive(:weighted_interest)
      match.calculate_rate
    end
  end

  context 'cal_total_repayment' do
    it 'can find the total repayment total when given an interest rate' do
    end
  end


end