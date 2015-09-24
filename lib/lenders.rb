require 'csv'

class Lender
  def convert_csv_to_array lender_resource
    lender_list_array = []
    offers = CSV.read(lender_resource, headers: true, header_converters: :symbol, converters: :numeric)
    offers.each do |offer_row|
      lender_list_array << offer_row.to_hash
    end
    sort_rates lender_list_array
  end

  def sort_rates lender_list_array
    sorted = lender_list_array.sort_by { |k| k[:rate] }
  end
end