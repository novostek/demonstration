class AddPermissionsToProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :permissions, :json
  end
end
