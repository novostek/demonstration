class ProductSchedule < ApplicationRecord
  belongs_to :product
  belongs_to :schedule

  accepts_nested_attributes_for :schedule, :reject_if => :all_blank, allow_destroy: true
end
