class CreateMeasurementAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_areas do |t|
      t.references :estimate, null: false, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
