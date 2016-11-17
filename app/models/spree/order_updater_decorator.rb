Spree::OrderUpdater.class_eval do
  def update_payment_state_with_create_3plcentral_order
    initial_state = order.payment_state
    result = update_payment_state_without_create_3plcentral_order
    create_3plcentral_order if initial_state != 'paid' && order.payment_state == 'paid'
    result
  end

  alias_method_chain :update_payment_state, :create_3plcentral_order

  private

  def create_3plcentral_order
    order.shipments.send_to_3plcentral.each(&:send_to_3plcentral)
  end
end
