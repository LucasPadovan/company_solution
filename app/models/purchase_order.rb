class PurchaseOrder < Order
  def update_prices
    # skips before_validation :update_prices

    false
  end

  private
  def get_certificates_available
    Permission.without_firm.only_valids.map { |permission| permission.certificate }.uniq
  end
end
