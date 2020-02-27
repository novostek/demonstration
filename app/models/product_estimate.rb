class ProductEstimate < ApplicationRecord
  belongs_to :product
  belongs_to :measurement_proposal
end
