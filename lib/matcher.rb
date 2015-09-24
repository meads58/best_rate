class Matcher

  def match_amount sorted_lender_list, borrow_amount
    if enough_funds?(sorted_lender_list, borrow_amount)
      calculate_rate(sorted_lender_list , borrow_amount)
    else
      'Cannot caclulate you request as there are not enough funds to match your request at the present time'
    end
  end

  def enough_funds? sorted_lender_list, borrow_amount
    (available_lender_amount(sorted_lender_list) >= borrow_amount) ? true : false
  end

  def available_lender_amount sorted_lender_list
    lender_amount = sorted_lender_list.map {|x| x[:avaliable].to_i }
    lender_total = lender_amount.inject(:+)
  end

  def calculate_rate sorted_lender_list, borrow_amount
    true
  end

  def matched_lenders sorted_lender_list, borrow_amount
    remaining_amount = borrow_amount
    rates_used = []
    sorted_lender_list.each do |row|
      row[:lent_amount] = calc_lent_amount(row[:avaliable],remaining_borrower)
      remaining_amount -= row[:avaliable]
      rates_used << row
    end
    rates_used
  end

  def calc_lent_amount lender_amount, remaining_borrower
    if remaining_borrower - lender_amount > 0
      lender_amount
    else
      remaining_borrower
    end
  end

end

{lender: 'Bob', rate: 0.05, avaliable: 300}
{lender: 'Jill', rate: 0.15, avaliable: 200}