class Main

  def initialize
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
    #implement the engine
  end

end

quote = Main.new
quote



