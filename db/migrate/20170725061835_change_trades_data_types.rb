class ChangeTradesDataTypes < ActiveRecord::Migration[5.1]
  def change
    remove_column :trades, :sold_by
    remove_column :trades, :sold_to
    add_column :trades, :sold_by, :integer
    add_column :trades, :sold_to, :integer
  end
end

