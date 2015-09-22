require 'csv'

class Offers
  def convert_to_array offer_resource
    array_of_offers = []
    offers = CSV.read(offer_resource, headers: true, header_converters: :symbol, converters: :numeric)
    offers.each do |offer_row|
      array_of_offers << offer_row.to_hash
    end
    array_of_offers
  end
end