class RemovePhotosFromMeasurementAreas < ActiveRecord::Migration[6.0]
  def change
    remove_column :measurement_areas, :photos, :json
  end
end
