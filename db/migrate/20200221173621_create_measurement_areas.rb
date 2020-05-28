class CreateMeasurementAreas < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_areas, id: :uuid do |t|
      t.references :estimate, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
