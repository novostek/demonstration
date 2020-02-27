# == Schema Information
#
# Table name: estimates
#
#  id                 :bigint           not null, primary key
#  bpmn_instance      :string
#  category           :string           not null
#  code               :string           not null
#  current            :boolean
#  description        :text             not null
#  latitude           :decimal(, )      not null
#  location           :string           not null
#  longitude          :decimal(, )      not null
#  price              :decimal(, )
#  status             :string           not null
#  tax                :decimal(, )
#  title              :string           not null
#  total              :decimal(, )      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lead_id            :bigint
#  order_id           :bigint
#  sales_person_id    :bigint
#  tax_calculation_id :bigint
#
# Indexes
#
#  index_estimates_on_lead_id             (lead_id)
#  index_estimates_on_order_id            (order_id)
#  index_estimates_on_sales_person_id     (sales_person_id)
#  index_estimates_on_tax_calculation_id  (tax_calculation_id)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sales_person_id => workers.id)
#  fk_rails_...  (tax_calculation_id => calculation_formulas.id)
#

class Estimate < ApplicationRecord
  after_initialize :initialize_code, if: :new_record?

  belongs_to :worker, optional: true
  belongs_to :order, optional: true
  belongs_to :lead, optional: true

  has_many :measurements, through: :measurement_areas
  has_many :measurement_areas, dependent: :destroy

  accepts_nested_attributes_for :measurement_areas, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :measurements, reject_if: :all_blank, allow_destroy: true

  has_many :schedules, -> { where origin: :Estimate }, primary_key: :id, foreign_key: :origin_id

  def initialize_code
    last_estimate = Estimate.last
    if last_estimate.present?
      self.code = last_estimate[:code].to_i + 1
    else
      self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
    end
  end
end
