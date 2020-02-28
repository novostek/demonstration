class CreateMeasurementProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :measurement_proposals do |t|
      t.text :notes

      t.timestamps
    end
  end
end
