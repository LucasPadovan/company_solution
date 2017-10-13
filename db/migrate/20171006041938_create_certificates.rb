class CreateCertificates < ActiveRecord::Migration[5.1]
  def change
    create_table :certificates do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :email
      t.integer :wait_time
      t.text :notes

      t.timestamps
    end
  end
end
