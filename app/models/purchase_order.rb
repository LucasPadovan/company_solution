class PurchaseOrder < Order
  private
  def get_certificates_available
    Permission.only_valids.where(firm_id: nil).map { |permission| permission.certificate }.uniq
  end
end
