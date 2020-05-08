class AddCustomFieldsToDocument < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :custom_fields, :json
  end
end
