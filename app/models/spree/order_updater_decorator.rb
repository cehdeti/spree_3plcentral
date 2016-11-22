module ThreePLCentralOrderUpdater
  def update_payment_state
    initial_state = order.payment_state
    super.tap { create_3plcentral_order if initial_state != 'paid' && order.payment_state == 'paid' }
  end

  private

  def create_3plcentral_order
    order.shipments.send_to_3plcentral.each(&:send_to_3plcentral)
  end
end

Spree::OrderUpdater.class_eval do
  prepend ThreePLCentralOrderUpdater
end
