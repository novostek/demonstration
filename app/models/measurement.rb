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
class Measurement < ApplicationRecord
  belongs_to :measurement_area, optional: true

  before_validation :set_default

  def self.square_meter areas_ids
    area = 0
    measurements = self.where(measurement_area_id: areas_ids)
    measurements.each do |m|
      if m.square_feet > 0
        area += m.square_feet

      elsif m.width > 0 and m.length > 0 and m.height > 0
        area = area + (m.width * m.length * m.height)

      elsif m.width > 0 and m.length > 0 
        area = area + (m.width * m.length)
      elsif m.width > 0 and m.height > 0
        area = area + (m.width * m.height)

      elsif m.width > 0 and m.length > 0 
        area = area + (m.width * m.length)
      elsif m.length > 0 and m.height > 0
        area = area + (m.length * m.height)

      elsif m.width > 0
        area += m.width
      elsif m.length > 0
        area += m.length
      elsif m.height > 0
        area += m.height
      end
    end

    return area.to_f
  end

  def set_default
    self.length ||= 0
    self.height ||= 0
    self.width ||= 0
    self.square_feet ||= 0
  end
end
