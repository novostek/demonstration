class CreateDocumentSends < ActiveRecord::Migration[6.0]
  def change
    create_table :document_sends do |t|
      t.string :origin
      t.integer :origin_id
      t.text :data

      t.timestamps
    end
  end
end
