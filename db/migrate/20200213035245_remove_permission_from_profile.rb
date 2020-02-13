class RemovePermissionFromProfile < ActiveRecord::Migration[6.0]
  def change

    remove_column :profiles, :permissions, :string
  end
end
