# == Schema Information
#
# Table name: measurement_areas
#
#  id             :uuid             not null, primary key
#  cloned_from    :uuid
#  description    :text
#  images         :string           default([]), is an Array
#  index_estimate :integer
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  estimate_id    :uuid             not null
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
  after_initialize :initialize_index_estimate, if: :set_index_estimate?
  belongs_to :estimate, optional: true
  has_many :measurements, inverse_of: :measurement_area, dependent: :destroy
  has_many :area_proposal, dependent: :destroy
  has_many :measurement_proposals, through: :area_proposal

  mount_uploaders :images, MeasurementAreaUploader
  #skip_callback :commit, :after, :remove_images!

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

  def set_index_estimate?
    !index_estimate.present?
  end

  def initialize_index_estimate
    self.index_estimate = DateTime.now.to_i
  end
end
