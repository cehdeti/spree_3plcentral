module Spree3PLCentral
  class UpdateOrders
    def run
      fetch_orders.each do |order|
        begin
          UpdateOrder.new(order).run
        rescue => ex
          logger.error ex.message
        end
      end
    end

    private

    def fetch_orders
      ThreePLCentral::Order.find(
        facilityID: ThreePLCentral.configuration.default_facility_id,
        customerID: ThreePLCentral.configuration.customer_id,
        limit: 1000
      )
    end
  end

  class UpdateOrder
    attr_accessor :api_order

    def initialize(api_order)
      self.api_order = api_order
    end

    def run
      return unless api_order['tracking_number']
      order = find_order || return
      order.shipments.ready.first.update!(
        tracking: api_order['tracking_number'],
        state: :shipped
      )
    end

    private

    def find_order
      number = api_order['reference_num'].sub(/\A#{Spree::Config.threeplcentral_user_login_id}-/, '')
      Spree::Order.find_by_number(number)
    end
  end
end
