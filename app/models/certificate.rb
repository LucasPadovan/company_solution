class Certificate < ApplicationRecord
  has_many :permissions
  has_many :details, class_name: 'CertificateDetail', dependent: :destroy

  accepts_nested_attributes_for :details,
    allow_destroy: true,
    reject_if: proc { |attributes| attributes[:product_id].blank? }

  def self.certificates_for_select
    Certificate.all.map{ |certificate| [certificate.name, certificate.id] }
  end
end
