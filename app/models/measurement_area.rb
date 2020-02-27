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
class MeasurementArea < ApplicationRecord
  belongs_to :estimate, optional: true
  has_many :measurements, inverse_of: :measurement_area, dependent: :destroy

  accepts_nested_attributes_for :measurements, reject_if: :reject_measurements, allow_destroy: true

  def reject_measurements attributes
    attributes['length'].blank? && attributes['width'].blank? && attributes['height'].blank?
  end
end
