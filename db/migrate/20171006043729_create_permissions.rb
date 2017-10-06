class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.date :from_date
      t.date :to_date
      t.references :certificate, foreign_key: true
      t.references :firm, foreign_key: true
      t.text :contact

      t.timestamps
    end
  end
end
