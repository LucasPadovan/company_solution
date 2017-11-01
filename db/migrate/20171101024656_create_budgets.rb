class CreateBudgets < ActiveRecord::Migration[5.1]
  def change
    create_table :budgets do |t|
      t.references :firm, foreign_key: true
      t.string :number
      t.date :date
      t.date :from
      t.date :to
      t.string :destinatary
      t.string :contact
      t.string :title
      t.string :header_image
      t.string :body_image
      t.string :pdf_file

      t.timestamps
    end
  end
end
