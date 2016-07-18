class AddSentToThreePlCentralToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :sent_to_threeplcentral, :boolean, null: true, default: nil
  end
end
