class Matcher

  def match? lender_list, borrow_amount
    value = lender_list.map {|x| x[:avaliable].to_i }
     if value[0] > borrow_amount
      true
    end
  end


end