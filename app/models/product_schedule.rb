# == Schema Information
#
# Table name: product_schedules
#
#  id          :uuid             not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :uuid             not null
#  schedule_id :uuid             not null
#
# Indexes
#
#  index_product_schedules_on_product_id   (product_id)
#  index_product_schedules_on_schedule_id  (schedule_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (schedule_id => schedules.id)
#
class ProductSchedule < ApplicationRecord
  belongs_to :product
  belongs_to :schedule

  accepts_nested_attributes_for :schedule, :reject_if => :all_blank, allow_destroy: true
end
