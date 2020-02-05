class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :category
      t.string :document_id
      t.date :since
      t.string :code
      t.date :birthdate

      t.timestamps
    end
  end
end
