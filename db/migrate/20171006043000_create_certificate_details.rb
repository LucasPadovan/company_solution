class CreateCertificateDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :certificate_details do |t|
      t.references :product, foreign_key: true
      t.references :certificate, foreign_key: true

      t.timestamps
    end
  end
end
