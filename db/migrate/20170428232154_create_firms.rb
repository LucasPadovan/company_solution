class CreateFirms < ActiveRecord::Migration[5.1]
  def change
    create_table :firms do |t|
      t.string :name
      t.string :cuit
      t.string :afip_condition

      t.timestamps
    end
  end
end
