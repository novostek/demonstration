class CreateMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :menus, id: :uuid do |t|
      t.boolean :active
      t.string :icon
      t.string :name
      t.string :url

      t.timestamps
    end
  end
end
