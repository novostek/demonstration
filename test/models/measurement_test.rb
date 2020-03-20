# == Schema Information
#
# Table name: measurements
#
#  id                  :bigint           not null, primary key
#  height              :decimal(, )
#  length              :decimal(, )
#  square_feet         :decimal(10, 2)
#  width               :decimal(, )
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  measurement_area_id :bigint           not null
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
