Spree::LineItem.class_eval do
  def to_threeplcentral
    {
      SKU: variant.sku,
      qty: quantity,
      fulfillment_sale_price: price,
      fulfillment_discount_amount: promo_total
    }
  end
end
