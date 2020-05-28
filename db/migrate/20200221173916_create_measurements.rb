class CreateMeasurements < ActiveRecord::Migration[6.0]
  def change
    create_table :measurements, id: :uuid do |t|
      t.references :measurement_area, null: false, foreign_key: true, type: :uuid
      t.decimal :width
      t.decimal :height
      t.decimal :length

      t.timestamps
    end
  end
end
