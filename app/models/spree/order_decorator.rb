Spree::Order.class_eval do
  def create_3plcentral_order
    shipments.send_to_3plcentral.each(&:send_to_3plcentral)
  end

  def finalize_with_create_3plcentral_order!
    result = finalize_without_create_3plcentral_order!
    create_3plcentral_order
    result
  end
  alias_method_chain :finalize!, :create_3plcentral_order

  def threeplcentral_reference_number
    "#{Spree::Config.threeplcentral_customer_id}-#{number}"
  end
end
