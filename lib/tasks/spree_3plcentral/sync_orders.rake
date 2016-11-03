namespace :spree_3plcentral do
  desc 'Sync status and tracking info for pending orders from 3PLCentral'
  task sync_orders: :environment do
    Rails.logger.tagged('3PLCentral sync') do
      Rails.logger.info 'Starting sync'

      shipments = Spree::Shipment.ready.sent_to_3plcentral
      total = shipments.count
      Rails.logger.info "Syncing #{total} order(s)"

      updated = shipments.select do |shipment|
        begin
          shipment.sync_3plcentral_state
        rescue => ex
          Rails.logger.error "Error syncing: #{ex.message}, shipment ID: #{shipment.id}"
          false
        end
      end.size

      Rails.logger.info "#{updated} updated and shipped, #{total - updated} not ready"
    end
  end
end
