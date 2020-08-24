# == Schema Information
#
# Table name: measurement_areas
#
#  id          :uuid             not null, primary key
#  cloned_from :uuid
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  estimate_id :uuid             not null
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
  has_many :area_proposal, dependent: :destroy
  has_many :measurement_proposals, through: :area_proposal

  accepts_nested_attributes_for :measurements, allow_destroy: true
  accepts_nested_attributes_for :measurement_proposals, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :area_proposal, reject_if: :all_blank, allow_destroy: true

  def reject_measurements attributes
    attributes['length'].blank? && attributes['width'].blank? && attributes['height'].blank?
  end

  def as_json(options = {})
    s = super(options)
    # s[:measurement_proposals] = self.measurement_proposals
    s
  end
end
