require_relative 'lenders'
require_relative 'matcher'

class Main

  attr_accessor :matcher

  def initialize options = {}
    @borrower_amount = 0
    @lend = Lender.new
    @matcher = Matcher.new
    correct_args

  end

  def main
    sorted_lenders = get_sorted_lenders_array
    matcher.match_amount(sorted_lenders, @borrower_amount)
  end

  def correct_args
    if ARGV.count != 2
      failed_validation 'plase supply a market file and loan amount'
    elsif check_loan_amount == false
      failed_validation 'Please supply and amount to borrow between £1000 and £15,000 and in £100 increments'
    else
      @borrower_amount = ARGV[1].to_i
      puts ARGV[0]
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
    puts validation_message
  end

  # def match_validation
  #   if @matcher.match?(lender_list, borrower_amount)
  #     @match.calculate_match
  #   else
  #     failed_validation 'Our avaliable funds cannot match your borrower request at this time'
  #   end
  # end
end

if __FILE__ == $0
 quote = Main.new
end




