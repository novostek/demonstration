class AddDataToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :data, :json
  end
end
