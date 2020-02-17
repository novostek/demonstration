class AddProfileToProfileMenu < ActiveRecord::Migration[6.0]
  def change
    add_reference :profile_menus, :profile, null: false, foreign_key: true
  end
end
