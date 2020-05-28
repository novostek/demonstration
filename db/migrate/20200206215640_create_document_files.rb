class CreateDocumentFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :document_files , id: :uuid do |t|
      t.string :title
      t.text :file
      t.string :origin
      t.uuid :origin_id
      t.boolean :esign
      t.json :esign_data
      t.string :photo
      t.date :photo_date
      t.text :photo_description

      t.timestamps
    end
  end
end
