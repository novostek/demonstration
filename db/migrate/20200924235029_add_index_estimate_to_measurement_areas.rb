class AddIndexEstimateToMeasurementAreas < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_areas, :index_estimate, :integer
  end
end
