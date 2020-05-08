class AddMainToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :main, :boolean
  end
end
