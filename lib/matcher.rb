class Matcher

  LOAN_DURATION = 36 

  attr_accessor :sorted_lenders, :borrow_amount

  def run_matcher sorted_lender_list, borrow_amount
    final_result = {}
    @sorted_lenders = sorted_lender_list
    @borrow_amount = borrow_amount
    if enough_funds? == true
      final_result[:weighted_rate] = calculate_rate
      final_result[:total_repayment] = calc_total_repayment(final_result[:weighted_rate])
      final_result[:monthly_repayment] = calc_monthly_repayment(final_result[:total_repayment])
      #final_result[:monthly_repayment] = calc_monthly_repayment(final_result[:total_repayment])
      final_result[:borrower_amount] = borrow_amount
    else
      final_result[:not_enough_funds] = 'Cannot caclulate your request as there are not enough funds to match your request at the present time'
    end
    final_result
  end

  def enough_funds? 
    (total_lenders_amount >= borrow_amount) ? true : false
  end

  def total_lenders_amount 
    lender_amount = sorted_lenders.map {|x| x[:available].to_i }
    lender_total = lender_amount.inject(:+)
  end

  def calculate_rate 
    matched_amounts = matched_lenders
    interest_rate = weighted_interest(matched_amounts)
  end

  def matched_lenders 
    remaining_amount = borrow_amount
    rates_used = []
    sorted_lenders.each do |row|
      row[:lent_amount] = calc_lent_amount(row[:available],remaining_amount)
      remaining_amount -= row[:available]
      rates_used << row
    end
    rates_used
  end

  def calc_lent_amount lender_amount, remaining_amount
    spread = remaining_amount - lender_amount
    case 
      when remaining_amount < 0
        0
      when spread > 0
        lender_amount
      else
        remaining_amount
    end
  end

  def weighted_interest matched_amounts
    interest = 0
    total_lent = 0
    matched_amounts.each do |row|
      interest += row[:rate] * row[:lent_amount]
      total_lent += row[:lent_amount]
    end
    weighted_interest_rate = interest / total_lent
  end

  def calc_total_repayment weighted_rate
    monthly_princial_amount = principal_repayment
    total_repayment = 0
    remaining_principal = borrow_amount
    1.upto(LOAN_DURATION) do |month|
      total_repayment += (monthly_princial_amount + monthly_interest(remaining_principal, weighted_rate))
      remaining_principal -= monthly_princial_amount
    end
    total_repayment
  end

  def monthly_interest interest_rate, amount
    months_interest = (amount * interest_rate) /12
  end

  def principal_repayment
    monthly_principal = borrow_amount.to_f / LOAN_DURATION
  end

  def calc_monthly_repayment total_repayment
    monthlty_repayment = total_repayment / LOAN_DURATION
    monthly_repayment.round(2)
  end
end
