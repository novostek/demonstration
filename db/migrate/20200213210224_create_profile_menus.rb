class CreateProfileMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :profile_menus do |t|
      t.string :profile_references
      t.references :menu, null: false, foreign_key: true

      t.timestamps
    end
  end
end
