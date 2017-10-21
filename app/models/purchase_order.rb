class PurchaseOrder < Order
  private
  def get_certificates_available
    Permission.without_firm.only_valids.map { |permission| permission.certificate }.uniq
  end
end
