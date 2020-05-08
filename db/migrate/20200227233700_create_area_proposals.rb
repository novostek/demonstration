class CreateAreaProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :area_proposals do |t|
      t.references :measurement_area, null: false, foreign_key: true
      t.references :measurement_proposal, null: false, foreign_key: true

      t.timestamps
    end
  end
end
