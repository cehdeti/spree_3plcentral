Spree::Order.class_eval do

  def threeplcentral_reference_number
    "#{Spree::Config.threeplcentral_reference_number_prefix}#{number}"
  end
end
