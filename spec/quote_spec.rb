require 'main'

describe Main do

  context 'checks for market file and loan amount when run.' do
    before(:each) do
      @quote = Main.new
    end
    it 'Runs the correct_args method when initialized.' do
      expect_any_instance_of(Main).to receive(:correct_args)
      Main.new
    end
    it "Will return the message 'plase supply a market file and loan amount' if the ARGV stream only has one argument" do
      stub_const("ARGV", ['market_file'])
      expect(@quote.correct_args).to eq 'plase supply a market file and loan amount'
    end
    it "Will return the message 'plase supply a market file and loan amount' if the ARGV stream has three arguments" do
      stub_const("ARGV", ['market file', 1000, 'some extra value'])
      expect(@quote.correct_args).to eq 'plase supply a market file and loan amount'
    end
    it "Will call the check_loan_amount method when a market file and loan amount are supplied" do
      stub_const("ARGV", ['market_file', 1000])
      expect(@quote).to receive(:check_loan_amount)
      @quote.correct_args
    end
  end

  context 'checks the loan range.' do
    before(:each) do
      @quote = Main.new
    end
    it 'Returns false when the loan value is less than 1000 e.g. 999' do
      stub_const("ARGV", ['market_file', 999])
      expect(@quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan amount is 1000' do
      stub_const("ARGV", ['market_file', 1000])
      expect(@quote.check_loan_amount).to be true
    end
    it 'Returns false when the loan is over 15000 e.g. 15001' do
      stub_const("ARGV", ['market_file', 15001])
      expect(@quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan is 15000' do
      stub_const("ARGV", ['market_file', 15000])
      expect(@quote.check_loan_amount).to be true
    end
  end

  context 'checks the loan is an increment of 100' do
    before(:each) do
      @quote = Main.new
    end
    it 'Returns false when the loan amount is NOT an increment of 100 but within the range limit e.g. 1005.' do
      stub_const("ARGV", ['market_file', 1005])
      expect(@quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan amount is an increment of 100 and within the range limit e.g. 1100' do
      stub_const("ARGV", ['market_file', 1100])
      expect(@quote.check_loan_amount).to be true
    end
  end

  context 'find best loan' do
    before(:each) do
      @quote = Main.new
    end
    it 'Calls find_best_loan if the check_loan_amount loan amount returns true' do
      stub_const("ARGV", ['market_file', 1100])
      expect(@quote).to receive(:find_best_deal)
      @quote.correct_args
    end
    it 'Exits if the check_loan_amount check returns false' do
      stub_const("ARGV", ['market_file', 1105])
      expect(@quote).to_not receive(:find_best_deal)
      @quote.correct_args
    end
  end

end