class MeasurementArea < ApplicationRecord
  belongs_to :estimate
  has_many :measurements, inverse_of: :measurement_area

  accepts_nested_attributes_for :measurements, allow_destroy: true, reject_if: :all_blank
end
