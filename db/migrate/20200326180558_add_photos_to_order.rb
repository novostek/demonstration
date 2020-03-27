class AddPhotosToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :photos, :json
  end
end
