class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :category
      t.string :title
      t.json :value
      t.string :origin
      t.uuid :origin_id

      t.timestamps
    end
  end
end
