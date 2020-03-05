class RemoveTypeFromDocument < ActiveRecord::Migration[6.0]
  def change

    remove_column :documents, :type, :string
  end
end
