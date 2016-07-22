Spree::Shipment.class_eval do
  scope :with_3plcentral, -> { joins(:shipping_methods).merge(Spree::ShippingMethod.with_3plcentral) }
  scope :sent_to_3plcentral, -> { where(sent_to_threeplcentral: true) }
  scope :not_sent_to_3plcentral, -> { where(sent_to_threeplcentral: [false, nil]) }
  scope :send_to_3plcentral, -> { where('1 = 1').merge(with_3plcentral).merge(not_sent_to_3plcentral) }

  def to_threeplcentral
    {
      trans_info: {
        reference_num: order.threeplcentral_reference_number,
      },
      ship_to: address.to_threeplcentral.merge(
        email_address1: order.email,
      ),
      shipping_instructions: shipping_method.to_threeplcentral,
      order_line_items: order.line_items.with_3plcentral.map do |line_item|
        { order_line_item: line_item.to_threeplcentral }
      end,
      fulfillment_info: {
        fulfill_inv_shipping_and_handling: order.shipment_total
      }
    }
  end

  def threeplcentral_order(reload = false)
    if reload || !instance_variable_defined?(:@threeplcentral_order)
      @threeplcentral_order = ThreePLCentral::Order
        .find(closed: 'Any', reference_num: order.threeplcentral_reference_number)
        .first
    end

    @threeplcentral_order
  end

  def send_to_3plcentral
    begin
      response = ThreePLCentral::Order.create(to_threeplcentral)
    rescue => ex
      logger.error("Error creating order in 3PLCentral: #{ex.message}")
      return false
    end

    unless response.body[:int32] == '1'
      update_column :sent_to_threeplcentral, false
      logger.error("Error creating order in 3PLCentral: #{response.body}")
      return false
    end

    update_column :sent_to_threeplcentral, true
    true
  end

  def sync_3plcentral_state
    threeplcentral_order && \
      threeplcentral_order['tracking_number'] && \
      update(tracking: threeplcentral_order['tracking_number']) && \
      ship!
  end
end
