class AddDescriptionToDocumentFile < ActiveRecord::Migration[6.0]
  def change
    add_column :document_files, :description, :text
  end
end
