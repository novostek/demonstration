# == Schema Information
#
# Table name: product_schedules
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint           not null
#  schedule_id :bigint           not null
#
# Indexes
#
#  index_product_schedules_on_product_id   (product_id)
#  index_product_schedules_on_schedule_id  (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (schedule_id => schedules.id)
#
require 'test_helper'

class ProductScheduleTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
