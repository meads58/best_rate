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
    it 'will return true if the borrow amount equals the available lenders total' do
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
    it 'can find the total available amount for all lenders' do
      expect(match.total_lenders_amount).to eq 500
    end
  end

  context 'run_matcher' do
    it 'will call caluclate_rate if there are enough available funds to lend out' do
      allow(match).to receive(:calc_total_repayment)
      allow(match).to receive(:calc_monthly_repayment)
      expect(match).to receive(:calculate_rate)
      match.run_matcher(@sorted_lender_list, @valid_borrower_amount)
    end

    it 'will call calc_total_repayment if there are enough available funds to lend out' do
      allow(match).to receive(:calculate_rate)
      allow(match).to receive(:calc_monthly_repayment)
      expect(match).to receive(:calc_total_repayment)
      match.run_matcher(@sorted_lender_list, @valid_borrower_amount)
    end

    it 'will call calc_monthly_repayment if there are enough available funds to lend out' do
      allow(match).to receive(:calculate_rate)
      allow(match).to receive(:calc_total_repayment)
      expect(match).to receive(:calc_monthly_repayment)
      match.run_matcher(@sorted_lender_list, @valid_borrower_amount)
    end

    it 'returns a hash with the total repayment amount, weighted interest rate and monthly repayments if there when there are sufficient funds' do
      allow(match).to receive(:enough_funds?).and_return(true)
      allow(match).to receive(:calculate_rate).and_return(0.05787)
      allow(match).to receive(:calc_total_repayment).and_return(100.553)
      allow(match).to receive(:calc_monthly_repayment).and_return(8.379442)
      expect(match.run_matcher('sorted_list', 100)).to include(:borrower_amount=>100,:weighted_rate=>0.05787, :total_repayment=>100.553, :monthly_repayment=>8.379442)
    end

    it "returns the message 'Cannot calculate your request as there are not enough funds to match your request at the present time' if the full borrower amount is not matched" do
      allow(match).to receive(:enough_funds?).and_return(false)
      expect(match.run_matcher(@sorted_lender_list, @invalid_borrower_amount)).to include({not_enough_funds: "Cannot calculate your request. We do not have the available funds for your request, try again with a smaller amount"})
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
    it 'can find the total repayment total when given an interest rate for Loan Duration constant of 36 months' do
      match.borrow_amount = 1000
      expect(match.calc_total_repayment(0.07)).to eq 1107.9166666666665
    end
  end

  context 'monthly_interest' do
    it ' can find the monthly interest when given an amount and interest rate' do
      interest_rate = 0.066
      amount = 1000
      expect(match.monthly_interest(interest_rate, amount)).to eq 5.5
    end
  end

  context 'principal_repayment' do
    it 'can calculate the monthly repayment to pay off the principal ONLY amount for the loan duration' do
      match.borrow_amount = 1000
      expect(match.principal_repayment).to eq 27.77777777777778
    end
  end

  context 'calc_monthly_repayment' do
    it 'can calculate the total monthly repayment(principal AND interest) for the loan duration' do
      expect(match.calc_monthly_repayment(1100)).to eq 30.555555555555557
    end
  end
end