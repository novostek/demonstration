class AddHourCostToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :hour_cost, :decimal
  end
end
