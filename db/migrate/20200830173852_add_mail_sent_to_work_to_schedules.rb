class AddMailSentToWorkToSchedules < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :mail_send_to_work, :boolean
  end
end
