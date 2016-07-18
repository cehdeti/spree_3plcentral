Spree::Shipment.class_eval do
  scope :with_3plcentral, -> { joins(:shipping_methods).merge(Spree::ShippingMethod.with_3plcentral) }
  scope :sent_to_3plcentral, -> { where(sent_to_threeplcentral: true) }

  alias_attribute :sent_to_3plcentral, :sent_to_threeplcentral

  self.state_machine.after_transition to: :ready,
                                      do: :create_3plcentral_order,
                                      if: :send_to_3plcentral?

  def send_to_3plcentral?
    !sent_to_3plcentral? && threeplcentral_create?
  end

  def to_threeplcentral
    {
      trans_info: {
        reference_num: order.number
      },
      ship_to: address.to_threeplcentral.merge(
        email_address1: order.email,
      ),
      shipping_instructions: shipping_methods.first.to_threeplcentral,
      order_line_items: order.line_items.with_3plcentral.map do |line_item|
        { order_line_item: line_item.to_threeplcentral }
      end,
      fulfillment_info: {
        fulfill_inv_shipping_and_handling: order.shipment_total
      }
    }
  end

  private

  def create_3plcentral_order
    begin
      response = ThreePLCentral::Order.create(to_threeplcentral)
    rescue => ex
      logger.error("Error creating order in 3PLCentral: #{ex.message}")
      return
    end

    if response.body[:int32] == '1'
      update_column :sent_to_threeplcentral, true
    else
      update_column :sent_to_threeplcentral, false
      logger.error("Error creating order in 3PLCentral: #{response.body}")
    end
  end

  def threeplcentral_create?
    shipping_methods.includes(:shipping_categories).any? do |shipping_method|
      shipping_method.shipping_categories.any?(&:threeplcentral_create?)
    end
  end
end
