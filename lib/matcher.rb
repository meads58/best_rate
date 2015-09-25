class Matcher

  attr_accessor :sorted_lenders, :borrow_amount

  def run_matcher sorted_lender_list, borrow_amount
    @sorted_lenders = sorted_lender_list
    @borrow_amount = borrow_amount
    if enough_funds?
      rate = calculate_rate
      total_repayment = cal_total_repayment(rate)
    else
      'Cannot caclulate your request as there are not enough funds to match your request at the present time'
    end
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

end
