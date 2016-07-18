Spree::LineItem.class_eval do
  scope :with_3plcentral, -> { joins(product: :shipping_category).merge(Spree::ShippingCategory.with_3plcentral) }

  def to_threeplcentral
    {
      SKU: variant.sku,
      qty: quantity,
      fulfillment_sale_price: price,
      fulfillment_discount_amount: promo_total
    }
  end
end
