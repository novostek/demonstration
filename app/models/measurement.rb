# == Schema Information
#
# Table name: measurements
#
#  id                  :bigint           not null, primary key
#  height              :decimal(, )
#  length              :decimal(, )
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
class Measurement < ApplicationRecord
  belongs_to :measurement_area, optional: true

  def self.square_meter areas_ids
    square_meter = 0
    measurements = self.where(measurement_area_id: areas_ids)
    measurements.each do |m|
      square_meter = square_meter + (m.length * m.width)
    end

    return square_meter.to_f
  end
end
