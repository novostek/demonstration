class CreateProfileMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :profile_menus, id: :uuid do |t|
      t.string :profile_references
      t.references :menu, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
