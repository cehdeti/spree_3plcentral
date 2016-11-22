module ThreePLCentralOrderUpdater
  def update_payment_state
    logger.tagged('3PLCentral', "Order ##{order.number}") do
      initial_state = order.payment_state
      logger.debug("Current order state: #{initial_state}")
      super.tap do
        logger.debug("New order state: #{order.payment_state}")
        create_3plcentral_order if initial_state != 'paid' && order.payment_state == 'paid'
      end
    end
  end

  private

  def logger
    order.try(:logger) || Rails.logger
  end

  def create_3plcentral_order
    logger.debug("#{__method__} with #{order.shipments.send_to_3plcentral.count} shipments")
    order.shipments.send_to_3plcentral.each(&:send_to_3plcentral)
    logger.debug("Done with #{__method__}")
  end
end

Spree::OrderUpdater.class_eval do
  prepend ThreePLCentralOrderUpdater
end
