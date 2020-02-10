class CreateDocumentFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :document_files do |t|
      t.string :title
      t.text :file
      t.string :origin
      t.integer :origin_id
      t.boolean :esign
      t.json :esign_data
      t.string :photo
      t.date :photo_date
      t.text :photo_description

      t.timestamps
    end
  end
end
