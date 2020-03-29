class AddTotalCostToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :total_cost, :decimal
  end
end
