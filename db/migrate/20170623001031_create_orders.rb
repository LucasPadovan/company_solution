class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.integer :number
      t.string :tracking_code
      t.string :type
      t.string :currency
      t.string :contact_name
      t.string :detail
      t.float :total
      t.float :subtotal
      t.float :taxes
      t.float :deliver_fee
      t.float :packaging_fee
      t.datetime :expected_deliver_from
      t.datetime :expected_deliver_to
      t.datetime :date
      t.references :firm
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
