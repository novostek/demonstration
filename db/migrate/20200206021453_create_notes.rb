class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :text, null: false
      t.boolean :private
      t.string :origin, null: false
      t.integer :origin_id, null: false

      t.timestamps
    end
  end
end
