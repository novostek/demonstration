class AddTitleToMeasurementProposal < ActiveRecord::Migration[6.0]
  def change
    add_column :measurement_proposals, :title, :string
  end
end
