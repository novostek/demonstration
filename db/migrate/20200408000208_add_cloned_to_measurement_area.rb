class AddClonedToMeasurementArea < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_areas, :cloned_from, :integer
  end
end
