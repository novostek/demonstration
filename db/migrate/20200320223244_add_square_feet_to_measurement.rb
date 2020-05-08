class AddSquareFeetToMeasurement < ActiveRecord::Migration[6.0]
  def change
    add_column :measurements, :square_feet, :decimal, precision: 10, scale: 2
  end
end
