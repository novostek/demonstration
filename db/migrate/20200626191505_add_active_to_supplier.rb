class AddActiveToSupplier < ActiveRecord::Migration[6.0]
  def change
    add_column :suppliers, :active, :boolean, default: true
  end
end
