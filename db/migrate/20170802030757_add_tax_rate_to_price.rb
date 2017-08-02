class AddTaxRateToPrice < ActiveRecord::Migration[5.1]
  def change
    add_column :prices, :tax_rate, :numeric
  end
end
