class CreateDocumentSends < ActiveRecord::Migration[6.0]
  def change
    create_table :document_sends, id: :uuid do |t|
      t.string :origin
      t.uuid :origin_id
      t.text :data

      t.timestamps
    end
  end
end
