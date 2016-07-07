Spree::Address.class_eval do
  def to_threeplcentral
    {
      address1: address.address1,
      address2: address.address2,
      city: address.city,
      state: address.state.abbr,
      zip: address.zipcode,
      country: address.country.name
    }
  end
end
