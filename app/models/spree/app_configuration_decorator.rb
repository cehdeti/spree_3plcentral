Spree::AppConfiguration.class_eval do
  preference :threeplcentral_api_key, :string
  preference :threeplcentral_login, :string
  preference :threeplcentral_password, :password
  preference :threeplcentral_user_login_id, :integer
  preference :threeplcentral_customer_id, :integer

  preference :threeplcentral_default_facility_id, :integer
end
