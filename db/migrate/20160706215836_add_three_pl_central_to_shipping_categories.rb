class AddThreePlCentralToShippingCategories < ActiveRecord::Migration
  def change
    add_column :spree_shipping_categories, :threeplcentral_create, :boolean, null: false, default: false
  end
end
