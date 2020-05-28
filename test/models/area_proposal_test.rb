# == Schema Information
#
# Table name: area_proposals
#
#  id                      :uuid             not null, primary key
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  measurement_area_id     :uuid             not null
#  measurement_proposal_id :uuid             not null
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
require 'test_helper'

class AreaProposalTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
