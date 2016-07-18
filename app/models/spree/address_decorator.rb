Spree::Address.class_eval do
  def to_threeplcentral
    {
      name: "#{firstname} #{lastname}",
      company_name: company || 'None',
      phone_number1: phone,
      address: {
        address1: address1, address2: address2, city: city, state: state.abbr,
        zip: zipcode, country: country.name
      }
    }
  end
end
