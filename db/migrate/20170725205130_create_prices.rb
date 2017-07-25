class CreatePrices < ActiveRecord::Migration[5.1]
  def change
    create_table :prices do |t|
      t.references :trade, foreign_key: true
      t.numeric :price
      t.numeric :min_quantity
      t.datetime :valid_from
      t.datetime :valid_to
      t.string :currency
      t.boolean :available

      t.timestamps
    end
  end
end
