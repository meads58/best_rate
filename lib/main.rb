require 'offers'

class Main

  def initialize options = {}
    @offers = Offers.new
    correct_args
  end

  def correct_args
    if ARGV.count == 2
      find_best_deal if check_loan_amount == true
    else
      'plase supply a market file and loan amount'
    end
  end

  def check_loan_amount
    loan_amount = ARGV[1].to_i
    loan_amount.between?(1000, 15000) && loan_amount % 100 == 0
  end

  def find_best_deal
    @test_file = "/Users/meads/Programming/Ruby/MakersAcademy/Projects/Zopa/best_rate/spec/test_offers.csv"
    offers = @offers.convert_to_array @test_file
  end

end

quote = Main.new(1)
quote



