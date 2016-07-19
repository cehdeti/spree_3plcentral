Spree::Order.class_eval do
  self.state_machine.after_transition to: :complete, do: :create_3plcentral_order

  private

  def create_3plcentral_order
    shipments.send_to_3plcentral.each(&:send_to_3plcentral)
  end
end
