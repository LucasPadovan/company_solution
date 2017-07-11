class CreateOrderLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.float :amount
      t.float :unit_price
      t.float :subtotal
      t.float :tax_rate
      t.float :tax
      t.float :remaining_amount
      t.integer :position
      t.string :currency
      t.string :detail

      t.timestamps
    end
  end
end
