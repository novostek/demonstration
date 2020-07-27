class AddMeasuresJsonToMeasurement < ActiveRecord::Migration[6.0]
  def change
    add_column :measurements, :measures, :json, default: {"value":[{"width":0.0,"length":0.0,"square_feet":0.0}]}
  end
end
