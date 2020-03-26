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
#  hour_cost     :decimal(, )
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

require 'test_helper'

class ScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
