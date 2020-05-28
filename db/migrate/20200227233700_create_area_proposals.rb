class CreateAreaProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :area_proposals, id: :uuid do |t|
      t.references :measurement_area, null: false, foreign_key: true, type: :uuid
      t.references :measurement_proposal, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
