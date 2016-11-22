Spree::OrderUpdater.class_eval do
  def update_payment_state_with_create_3plcentral_order
    logger.tagged('3PLCentral', "Order ##{order.number}") do
      initial_state = order.payment_state
      logger.debug("Current order state: #{initial_state}")
      update_payment_state_without_create_3plcentral_order.tap do
        logger.debug("New order state: #{order.payment_state}")
        create_3plcentral_order if initial_state != 'paid' && order.payment_state == 'paid'
      end
    end
  end

  alias_method_chain :update_payment_state, :create_3plcentral_order

  private

  def create_3plcentral_order
    order.shipments.send_to_3plcentral.each(&:send_to_3plcentral)
  end
end
