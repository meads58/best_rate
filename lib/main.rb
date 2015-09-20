class Main

  def initialize
    correct_args
    puts ARGV
  end

  def correct_args
    if ARGV.count == 2
      check_loan_amount
    else
      'plase supply a market file and loan amount'
    end
  end

  def check_loan_amount
    loan_amount = ARGV[1]
    loan_amount.between?(1000, 15000) && loan_amount % 100 == 0
  end

end

quote = Main.new
quote



