class CreateDocumentCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :document_custom_fields do |t|
      t.string :name
      t.references :document, null: false, foreign_key: true

      t.timestamps
    end
  end
end
