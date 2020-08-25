class AddAllDayToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :all_day, :boolean
  end
end
