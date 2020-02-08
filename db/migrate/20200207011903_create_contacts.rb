class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :category
      t.string :title
      t.json :value
      t.string :origin
      t.integer :origin_id

      t.timestamps
    end
  end
end
