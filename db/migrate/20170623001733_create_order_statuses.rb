class CreateOrderStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :order_statuses do |t|
      t.references :order, foreign_key: true
      t.numeric :status
      t.string :detail

      t.timestamps
    end
  end
end
