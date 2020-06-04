class RemoveOriginIdFromSchedule < ActiveRecord::Migration[6.0]
  def change

    remove_column :schedules, :origin_id, :integer
  end
end
