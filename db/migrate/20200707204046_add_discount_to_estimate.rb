class AddDiscountToEstimate < ActiveRecord::Migration[6.0]
  def change
    add_column :estimates, :discount, :decimal, default: 0.0, precision: 10, scale: 2
  end
end
