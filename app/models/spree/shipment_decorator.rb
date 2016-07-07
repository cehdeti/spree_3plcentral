Spree::Shipment.class_eval do
  self.state_machine.after_transition to: :ready, do: :create_3plcentral_order

  def to_threeplcentral
    today = Date.today.strftime('%Y-%m-%d')
    {
      trans_info: {
        reference_num: order.number,
        expected_date: today,
        earliest_ship_date: today,
        ship_cancel_date: today
      },
      ship_to: {
        name: "#{address.firstname} #{address.lastname}",
        company_name: address.company,
        address: address.to_threeplcentral,
        phone_number1: address.phone,
        email_address1: order.email,
        shipping_instructions: {
          mode: shipping_methods.first.name
        }
      },
      order_line_items: order.line_items.map(&:to_threeplcentral),
      fulfillment_info: {
        fulfill_inv_shipping_and_handling: order.shipment_total,
        fulfill_inv_tax: order.included_tax_total
      }
    }
  end

  private

  def create_3plcentral_order
    return if threeplcentral_order_id || !threeplcentral_create?

    begin
      order_id = ThreePLCentral::Order.create(to_threeplcentral)
      update_column :threeplcentral_order_id, order_id
    rescue => ex
      logger.error(ex.message)
    end
  end

  def threeplcentral_create?
    shipping_methods.includes(:shipping_categories).any? do |shipping_method|
      shipping_method.shipping_categories.any?(&:threeplcentral_create?)
    end
  end
end
