class AddThreePlCentralOrderIdToShipments < ActiveRecord::Migration
  def change
    add_column :spree_shipments, :threeplcentral_order_id, :integer, null: true, default: nil
  end
end
