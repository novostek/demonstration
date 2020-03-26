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
class Measurement < ApplicationRecord
  belongs_to :measurement_area, optional: true
  
  before_validation :set_default

  def self.square_meter areas_ids
    square_meter = 0
    measurements = self.where(measurement_area_id: areas_ids)
    measurements.each do |m|
      square_meter = square_meter + (m.length * m.width)
    end

    return square_meter.to_f
  end

  def set_default
    self.length = self.length || 0
    self.height = self.height || 0
    self.width = self.width || 0
    self.square_feet = self.square_feet || 0
  end
end
