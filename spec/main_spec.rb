require 'main'
require 'spec_helper'

MARKET_FILE = "/Users/meads/Programming/Ruby/MakersAcademy/Projects/Zopa/best_rate/spec/test_offers.csv"


describe Main do
  let(:quote) {Main.new}

  before(:each) do
    stub_const("ARGV", [MARKET_FILE])
  end
  context 'checks for market file and loan amount when run.' do

    it 'Runs the correct_args method when initialized.' do
      stub_const("ARGV", [MARKET_FILE])
      expect_any_instance_of(Main).to receive(:correct_args)
      Main.new
    end
    it "Will return the message 'plase supply a market file and loan amount' if the ARGV stream only has one argument" do
      stub_const("ARGV", [MARKET_FILE])
      expect(quote).to receive(:failed_validation).with('plase supply a market file and loan amount')
      quote.correct_args
    end
    it "Will return the message 'plase supply a market file and loan amount' if the ARGV stream has three arguments" do
      stub_const("ARGV", [MARKET_FILE, 1000, 'some extra value'])
      expect(quote).to receive(:failed_validation).with('plase supply a market file and loan amount')
      quote.correct_args
    end
  end

  context 'checks the loan range.' do
    it 'Returns false when the loan value is less than 1000 e.g. 999' do
      stub_const("ARGV", [MARKET_FILE, 999])
      expect(quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan amount is 1000' do
      stub_const("ARGV", [MARKET_FILE, 1000])
      expect(quote.check_loan_amount).to be true
    end
    it 'Returns false when the loan is over 15000 e.g. 15001' do
      stub_const("ARGV", [MARKET_FILE, 15001])
      expect(quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan is 15000' do
      stub_const("ARGV", [MARKET_FILE, 15000])
      expect(quote.check_loan_amount).to be true
    end
  end

  context 'checks the loan is an increment of 100' do
    it 'Returns false when the loan amount is NOT an increment of 100 but within the range limit e.g. 1005.' do
      stub_const("ARGV", [MARKET_FILE, 1005])
      expect(quote.check_loan_amount).to be false
    end
    it 'Returns true when the loan amount is an increment of 100 and within the range limit e.g. 1100' do
      stub_const("ARGV", [MARKET_FILE, 1100])
      expect(quote.check_loan_amount).to be true
    end
  end

  context 'get_sorted_lenders_array' do
    it 'Calls find_best_loan if the check_loan_amount loan amount returns true' do
      lender = class_double("Lender")
      expect(quote).to receive_message_chain("lend", "convert_csv_to_array")
      quote.get_sorted_lenders_array
    end
  end

  context 'failed validation' do
    it 'puts out the failed message' do
      expect(STDOUT).to receive(:puts).with('failed message')
      quote.failed_validation 'failed message'
    end
  end

end