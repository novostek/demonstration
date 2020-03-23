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
#  link               :text
#  location           :string           not null
#  longitude          :decimal(, )      not null
#  price              :decimal(, )
#  status             :string           not null
#  tax                :decimal(, )
#  taxpayer           :string
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
#  index_estimates_on_taxpayer            (taxpayer)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sales_person_id => workers.id)
#  fk_rails_...  (tax_calculation_id => calculation_formulas.id)
#

require 'test_helper'

class EstimateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
