class AddUnitToOrderLine < ActiveRecord::Migration[5.1]
  def change
    add_column :order_lines, :unit, :string
    remove_column :order_lines, :currency
  end
end
