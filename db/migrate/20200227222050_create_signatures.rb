class CreateSignatures < ActiveRecord::Migration[6.0]
  def change
    create_table :signatures do |t|
      t.string :origin
      t.integer :origin_id
      t.text :file

      t.timestamps
    end
  end
end
