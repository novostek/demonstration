class AddSendMailToSchedule < ActiveRecord::Migration[6.0]
  def change
    add_column :schedules, :send_mail, :boolean
    add_column :schedules, :mail_sent, :boolean
  end
end
