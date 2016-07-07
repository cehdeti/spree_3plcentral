Deface::Override.new(
  virtual_path: "spree/admin/shipping_categories/_form",
  name: "add_3plcentral_to_admin_shipping_category_edit",
  insert_bottom: "[data-hook='admin_shipping_category_form_fields']",
  partial: "spree/admin/shipping_categories/edit_3plcentral"
)
