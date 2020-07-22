# == Schema Information
#
# Table name: measurements
#
#  id                  :uuid             not null, primary key
#  height              :decimal(, )
#  length              :decimal(, )
#  measures            :json
#  square_feet         :decimal(10, 2)
#  width               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  measurement_area_id :uuid             not null
#
# Indexes
#
#  index_measurements_on_measurement_area_id  (measurement_area_id)
#
# Foreign Keys
#
#  fk_rails_...  (measurement_area_id => measurement_areas.id)
#
require 'test_helper'

class MeasurementTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
