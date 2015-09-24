require_relative 'lenders'
require_relative 'matcher'

class Main

  attr_accessor :matcher, :lender_list

  def initialize options = {}
    @lend = Lender.new
    @matcher = Matcher.new
    correct_args
    main 
  end

  def main
    find_best_deal
  end

  def correct_args
    if ARGV.count != 2
      failed_validation 'plase supply a market file and loan amount'
    elsif check_loan_amount == false
      failed_validation 'Please supply and amount to borrow between £1000 and £15,000 and in £100 increments'    
    end
  end

  def check_loan_amount
    loan_amount = ARGV[1].to_i
    loan_amount.between?(1000, 15000) && loan_amount % 100 == 0
  end

  def find_best_deal
    @test_file = "/home/meads/Workspace/tech_test/best_rate/spec/test_offers.csv"
    lender_list = @lend.convert_csv_to_array @test_file
  end

  def failed_validation validation_message
    puts validation_message
  end
end

 quote = Main.new
 #uote.main



