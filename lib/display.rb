class Display
require 'colorize'

	def reporter final_result
		if final_result.has_key?(:not_enough_funds)
			puts final_result[:not_enough_funds].colorize(:yellow).on_black.underline
		else
			puts "Requested amount: " + "£#{final_result[:borrower_amount]}".colorize(:red)
			puts "Rate: " + "#{humanize_rate(final_result[:weighted_rate])}%".colorize(:red)
			puts "Monthly repayment: " + "£#{format_repayment_amounts(final_result[:monthly_repayment])}".colorize(:red)
			puts "Total repayment: " +  "£#{format_repayment_amounts(final_result[:total_repayment])}".colorize(:red)
		end
	end

	def humanize_rate rate
		(rate * 100).round(2)
	end

	def format_repayment_amounts amount
		amount.round(2)
	end

  def failed_msg message
    puts message.colorize(:yellow).on_black.underline
  end
end
