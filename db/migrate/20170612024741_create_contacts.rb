class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :area
      t.text :details
      t.references :firm, foreign_key: true

      t.timestamps
    end
  end
end
