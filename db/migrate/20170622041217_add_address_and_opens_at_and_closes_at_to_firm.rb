class AddAddressAndOpensAtAndClosesAtToFirm < ActiveRecord::Migration[5.1]
  def change
    add_column :firms, :address, :string
    add_column :firms, :opens_at, :time
    add_column :firms, :closes_at, :time
  end
end
