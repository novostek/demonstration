class AddNullToField < ActiveRecord::Migration[6.0]
  def change
    change_column_null :product_estimates, :product_id, true
  end
end
