class AddLatitudeAndLongitudeNullToEstimate < ActiveRecord::Migration[6.0]
  def change
    change_column_null :estimates, :latitude, true
    change_column_null :estimates, :longitude, true
  end
end
