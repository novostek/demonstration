class Schedule < ApplicationRecord
  belongs_to :order
  belongs_to :worker
end
