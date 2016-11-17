Spree::Shipment.class_eval do
  scope :with_3plcentral, -> { joins(:shipping_methods).merge(Spree::ShippingMethod.with_3plcentral) }
  scope :sent_to_3plcentral, -> { where(sent_to_threeplcentral: true) }
  scope :not_sent_to_3plcentral, -> { where(sent_to_threeplcentral: [false, nil]) }
  scope :send_to_3plcentral, -> { where('1 = 1').merge(with_3plcentral).merge(not_sent_to_3plcentral) }

  def to_threeplcentral
    {
      trans_info: {
        reference_num: threeplcentral_reference_number,
      },
      ship_to: address.to_threeplcentral.merge(
        email_address1: order.email,
      ),
      shipping_instructions: shipping_method.to_threeplcentral,
      order_line_items: line_items.map do |line_item|
        { order_line_item: line_item.to_threeplcentral }
      end,
      fulfillment_info: {
        fulfill_inv_shipping_and_handling: order.shipment_total
      }
    }
  end

  def threeplcentral_reference_number
    "#{Spree::Config.threeplcentral_reference_number_prefix}#{order.number}-#{number}"
  end

  def threeplcentral_order(reload = false)
    if reload || !instance_variable_defined?(:@threeplcentral_order)
      @threeplcentral_order = ThreePLCentral::Order
        .find(closed: 'Any', reference_num: threeplcentral_reference_number)
        .first
    end

    @threeplcentral_order
  end

  def send_to_3plcentral
    logger.tagged('3PLCentral') do
      logger.debug 'Creating shipment record'
      success = Rails.env.production? ? do_send_to_3plcentral : simulate_send_to_3plcentral
      update_column :sent_to_threeplcentral, success
    end
  end

  def sync_3plcentral_state
    threeplcentral_order && \
      threeplcentral_order['tracking_number'] && \
      update(tracking: threeplcentral_order['tracking_number']) && \
      ship!
  end

  private

  def do_send_to_3plcentral
    response = ThreePLCentral::Order.create(to_threeplcentral)
    success = response.body[:int32] == '1'
    logger.error("Error creating shipment: #{response.body}") unless success
    success
  rescue => ex
    logger.error("Error creating shipment: #{ex.message}")
    false
  end

  def simulate_send_to_3plcentral
    logger.debug("Not in production environment, skipping 3PLCentral shipment creation. Would have sent: #{to_threeplcentral}")
    true
  end
end
