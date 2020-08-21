class AddImagesToMeasurementArea < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_areas, :images, :string, array: true, default: [] # add images column as array
  end
end
