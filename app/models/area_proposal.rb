# == Schema Information
#
# Table name: area_proposals
#
#  id                      :bigint           not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  measurement_area_id     :bigint           not null
#  measurement_proposal_id :bigint           not null
#
# Indexes
#
#  index_area_proposals_on_measurement_area_id      (measurement_area_id)
#  index_area_proposals_on_measurement_proposal_id  (measurement_proposal_id)
#
# Foreign Keys
#
#  fk_rails_...  (measurement_area_id => measurement_areas.id)
#  fk_rails_...  (measurement_proposal_id => measurement_proposals.id)
#
class AreaProposal < ApplicationRecord
  belongs_to :measurement_area
  belongs_to :measurement_proposal
end
