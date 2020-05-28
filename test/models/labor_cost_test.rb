# == Schema Information
#
# Table name: labor_costs
#
#  id          :uuid             not null, primary key
#  date        :date
#  status      :string
#  value       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :uuid             not null
#  worker_id   :uuid             not null
#
# Indexes
#
#  index_labor_costs_on_schedule_id  (schedule_id)
#  index_labor_costs_on_worker_id    (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (schedule_id => schedules.id)
#  fk_rails_...  (worker_id => workers.id)
#
require 'test_helper'

class LaborCostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
