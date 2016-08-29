Spree::OrderUpdater.class_eval do

  def create_3plcentral_order
    if order.payment_state=='paid'
      order.shipments.send_to_3plcentral.each(&:send_to_3plcentral)
    end
  end

  def update_payment_state_with_create_3plcentral_order
    result = update_payment_state_without_create_3plcentral_order
    create_3plcentral_order
    result
  end

  alias_method_chain :update_payment_state, :create_3plcentral_order

end