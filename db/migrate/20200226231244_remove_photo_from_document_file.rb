class RemovePhotoFromDocumentFile < ActiveRecord::Migration[6.0]
  def change

    remove_column :document_files, :photo, :string

    remove_column :document_files, :photo_date, :date

    remove_column :document_files, :photo_description, :text
  end
end
