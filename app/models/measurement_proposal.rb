# == Schema Information
#
# Table name: measurement_proposals
#
#  id         :bigint           not null, primary key
#  notes      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class MeasurementProposal < ApplicationRecord
  has_many :area_proposal
  has_many :measurement_area, through: :area_proposal
  has_many :product_estimates, inverse_of: :measurement_proposal, dependent: :destroy

  accepts_nested_attributes_for :product_estimates, reject_if: :all_blank, allow_destroy: true

  def as_json(options = {})
    s = super(options)
    s[:product_estimates] = self.product_estimates
    s[:measurement_area] = self.measurement_area
    s
  end
end
