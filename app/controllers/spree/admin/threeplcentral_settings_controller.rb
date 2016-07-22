module Spree
  module Admin
    class ThreePLCentralSettingsController < Spree::Admin::BaseController
      CREDENTIAL_FIELDS = [
        :threeplcentral_api_key,
        :threeplcentral_login,
        :threeplcentral_password,
        :threeplcentral_user_login_id
      ].freeze
      PREFERENCE_FIELDS = [
        :threeplcentral_customer_id,
        :threeplcentral_default_facility_id,
        :threeplcentral_reference_number_prefix
      ].freeze

      before_action :set_fields, :set_shipping_categories

      def edit
      end

      def update
        params.slice(*@fields).each do |name, value|
          Spree::Config[name] = value if Spree::Config.has_preference? name
        end

        @error = Spree3PLCentral.test

        if @error
          render :edit
        else
          flash[:success] = Spree.t(:successfully_updated, resource: Spree.t(:threeplcentral_settings))
          redirect_to edit_admin_threeplcentral_settings_path
        end
      end

      private

      def set_fields
        @credential_fields = CREDENTIAL_FIELDS
        @preference_fields = PREFERENCE_FIELDS
        @fields = (@credential_fields + @preference_fields).freeze
      end

      def set_shipping_categories
        @shipping_categories = Spree::ShippingCategory.with_3plcentral
      end
    end
  end
end
