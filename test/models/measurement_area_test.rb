# == Schema Information
#
# Table name: measurement_areas
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  estimate_id :bigint           not null
#
# Indexes
#
#  index_measurement_areas_on_estimate_id  (estimate_id)
#
# Foreign Keys
#
#  fk_rails_...  (estimate_id => estimates.id)
#
require 'test_helper'

class MeasurementAreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
