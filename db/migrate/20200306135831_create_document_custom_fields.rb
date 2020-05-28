class CreateDocumentCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :document_custom_fields, id: :uuid do |t|
      t.string :name
      t.references :document, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
