class CreateTrades < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.references :product, foreign_key: true
      t.numeric :sold_by
      t.numeric :sold_to
      t.datetime :from
      t.datetime :to

      t.timestamps
    end
  end
end
