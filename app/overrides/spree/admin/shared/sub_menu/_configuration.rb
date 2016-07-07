Deface::Override.new(
  virtual_path:  "spree/admin/shared/sub_menu/_configuration",
  name: "add_3plcentral_admin_menu_link",
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item '3PLCentral Settings', edit_admin_threeplcentral_settings_path %>"
)
