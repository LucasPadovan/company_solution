class AddInternalsToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :internal_name, :string
    add_column :products, :internal_code, :string
    add_column :products, :external_code, :string
  end
end
