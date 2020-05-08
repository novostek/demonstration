class RemoveProfileReferencesFromProfileMenu < ActiveRecord::Migration[6.0]
  def change

    remove_column :profile_menus, :profile_references, :string
  end
end
