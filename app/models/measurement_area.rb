class MeasurementArea < ApplicationRecord
  belongs_to :estimate
  has_many :measurement
end
