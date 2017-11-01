class CreateBudgetLines < ActiveRecord::Migration[5.1]
  def change
    create_table :budget_lines do |t|
      t.references :budget, foreign_key: true
      t.references :product, foreign_key: true
      t.float :unit_price
      t.string :currency
      t.float :tax_rate
      t.string :unit
      t.integer :position
      t.float :price_change

      t.timestamps
    end
  end
end
