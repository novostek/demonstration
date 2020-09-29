class ChangeDataTypeForIndexEstimate < ActiveRecord::Migration[6.0]
  def self.up
    change_table :measurement_areas do |t|
      t.change :index_estimate, :string
    end
  end
  def self.down
    change_table :measurement_areas do |t|
      t.change :index_estimate, :integer
    end
  end
end
