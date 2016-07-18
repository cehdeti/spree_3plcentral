Spree::ShippingMethod.class_eval do
  scope :with_3plcentral, -> { joins(:shipping_categories).merge(Spree::ShippingCategory.with_3plcentral) }

  def to_threeplcentral
    {
      carrier: carrier || 'N/A',
      mode: mode || admin_name,
      billing_code: code || 'N/A'
    }
  end

  private

  def carrier
    admin_name.split(' ').first
  end

  def mode
    admin_name.split(' ', 2).last
  end
end
