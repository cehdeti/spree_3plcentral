namespace :spree_3plcentral do
  desc 'Sends unsent orders to 3PLCentral'
  task send_orders: :environment do
    Rails.logger.debug '3PLCentral send orders: Starting send'

    shipments = Spree::Shipment.with_3plcentral.where(:sent_to_threeplcentral =>nil)
    total = shipments.count
    Rails.logger.debug "3PLCentral send orders: Sending #{total} order(s)"

    shipments.each do |shipment|
      begin
        shipment.send_to_3plcentral
      rescue => ex
        Rails.logger.error "3PLCentral send orders: Error sending: #{ex.message}, shipment ID: #{shipment.id}"
        false
      end
    end

    Rails.logger.debug "3PLCentral send orders: sent #{total} shipments"
  end
end
