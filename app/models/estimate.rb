class Estimate < ApplicationRecord
  belongs_to :worker
  belongs_to :order
  belongs_to :lead
end
