task send_orders: :environment do
  Rails.logger.tagged('3PLCentral send Orders') do
    Rails.logger.info 'Starting send'

    shipments = Spree::Shipment.with_3plcentral.where(:sent_to_threeplcentral =>nil)
    total = shipments.count
    Rails.logger.info "Sending #{total} order(s)"

    shipments.each do |shipment|
      begin
        shipment.send_to_3plcentral
      rescue => ex
        Rails.logger.error "Error sending: #{ex.message}, shipment ID: #{shipment.id}"
        false
      end
    end

    Rails.logger.info "sent #{total} shipments"
  end
end
