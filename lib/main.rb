require_relative 'lenders'
require_relative 'matcher'
require_relative 'display'

class Main

  attr_accessor :matcher, :display

  def initialize options = {}
    @borrower_amount = 0
    @lend = Lender.new
    @matcher = Matcher.new
    @display = Display.new
    correct_args
  end

  def main
    sorted_lenders = get_sorted_lenders_array
    display.reporter(matcher.run_matcher(sorted_lenders, @borrower_amount))
  end

  def correct_args
    if ARGV.count != 2
      failed_validation 'please supply a market file and loan amount'
    elsif check_loan_amount == false
      failed_validation 'Please supply an amount to borrow between £1000 and £15,000 and in £100 increments'
    else
      @borrower_amount = ARGV[1].to_i
      main
    end
  end

  def check_loan_amount
    loan_amount = ARGV[1].to_i
    loan_amount.between?(1000, 15000) && loan_amount % 100 == 0
  end

  def get_sorted_lenders_array
    test_file = ARGV[0]
    @lend.convert_csv_to_array test_file
  end

  def failed_validation validation_message
    display.failed_msg(validation_message)
  end
end

if __FILE__ == $0
 quote = Main.new
end




