Spree::ShippingCategory.class_eval do
  scope :with_3plcentral, -> { where(threeplcentral_create: true) }
end
