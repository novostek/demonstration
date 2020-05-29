class ProductSchedule < ApplicationRecord
  belongs_to :product
  belongs_to :schedule
end
