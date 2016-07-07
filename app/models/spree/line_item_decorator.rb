Spree::LineItem.class_eval do
  def to_threeplcentral
    {
      sku: variant.sku,
      qty: quantity,
      fulfillment_sale_price: price,
      fulfillment_discount_amount: promo_total
    }
  end
end
