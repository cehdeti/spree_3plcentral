require 'spree_core'
require 'spree_3plcentral/engine'
require '3pl_central'

module Spree3PLCentral
  class << self
    # Tests the connection to the 3PLCentral API using the stored credentials.
    #
    # Returns an exception-like value if it fails, `nil` if successful.
    def test
      init_client!
      response = ThreePLCentral::Services.stock_status(ThreePLCentral::Base.read_creds)
      OpenStruct.new(message: response.body) if response.http.error?
    rescue => ex
      ex
    end

    # Reloads the 3PLCentral API client with the stored credentials.
    #
    # This method should be called after updating the API credentials stored in
    # Spree's configuration system.
    def init_client!
      ThreePLCentral.configure do |c|
        c.three_pl_key = Spree::Config.threeplcentral_api_key
        c.login = Spree::Config.threeplcentral_login
        c.password = Spree::Config.threeplcentral_password
        c.three_pl_id = Spree::Config.threeplcentral_user_login_id
        c.customer_id = Spree::Config.threeplcentral_customer_id
        c.default_facility_id = Spree::Config.threeplcentral_default_facility_id
      end
    end
  end
end
