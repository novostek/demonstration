# == Schema Information
#
# Table name: schedules
#
#  id                :uuid             not null, primary key
#  all_day           :boolean
#  bpmn_instance     :string
#  category          :string
#  color             :string
#  description       :text
#  end_at            :datetime
#  hour_cost         :decimal(, )
#  mail_send_to_work :boolean
#  mail_sent         :boolean
#  origin            :string
#  send_mail         :boolean
#  start_at          :datetime
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  origin_id         :uuid
#  worker_id         :uuid             not null
#
# Indexes
#
#  index_schedules_on_worker_id  (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (worker_id => workers.id)
#

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
