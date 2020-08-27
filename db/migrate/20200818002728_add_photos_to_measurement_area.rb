class AddPhotosToMeasurementArea < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_areas, :photos, :json
  end
end
