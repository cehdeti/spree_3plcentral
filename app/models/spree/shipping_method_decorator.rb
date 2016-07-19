Spree::ShippingMethod.class_eval do
  scope :with_3plcentral, -> { joins(:shipping_categories).merge(Spree::ShippingCategory.with_3plcentral) }

  def to_threeplcentral
    {
      carrier: carrier || 'N/A',
      mode: admin_name
    }
  end

  private

  def carrier
    admin_name.split(' ').first
  end
end
