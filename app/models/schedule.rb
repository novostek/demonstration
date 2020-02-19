# == Schema Information
#
# Table name: schedules
#
#  id            :bigint           not null, primary key
#  bpmn_instance :string
#  category      :string
#  color         :string
#  description   :text
#  end_at        :datetime
#  origin        :string
#  start_at      :datetime
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  origin_id     :integer
#  worker_id     :bigint           not null
#
# Indexes
#
#  index_schedules_on_worker_id  (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (worker_id => workers.id)
#

class Schedule < ApplicationRecord
  belongs_to :worker

  def self.new_schedule object
    begin
      schedule = self.new
      schedule.title = object[:title]
      schedule.category = object[:category]
      schedule.description = object[:description]
      schedule.start_at = object[:start_at]
      schedule.end_at = object[:end_at]
      schedule.color = object[:color]
      schedule.worker_id = object[:worker_id]
      schedule.origin = object[:origin]
      schedule.origin_id = object[:origin_id]

      schedule.save
    rescue StandardError => e
      return {
        :error => e.message
      }
    end
  end
end
