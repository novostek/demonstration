class CreateSignatures < ActiveRecord::Migration[6.0]
  def change
    create_table :signatures, id: :uuid do |t|
      t.string :origin
      t.uuid :origin_id
      t.text :file

      t.timestamps
    end
  end
end
