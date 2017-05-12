class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :area
      t.references :user, foreign_key: true
      t.string :type
      t.string :unit
      t.numeric :initial_stock
      t.numeric :current_stock

      t.timestamps
    end
  end
end
