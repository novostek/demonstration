class AreaProposal < ApplicationRecord
  belongs_to :measurement_area
  belongs_to :measurement_proposal
end
