class AddDocTypeToDocument < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :doc_type, :string
  end
end
