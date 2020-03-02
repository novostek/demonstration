# == Schema Information
#
# Table name: product_estimates
#
#  id                      :bigint           not null, primary key
#  custom_title            :string
#  discount                :decimal(, )
#  notes                   :text
#  quantity                :decimal(, )
#  tax                     :boolean
#  unitary_value           :decimal(, )
#  value                   :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  measurement_proposal_id :bigint           not null
#  product_id              :bigint           not null
#
# Indexes
#
#  index_product_estimates_on_measurement_proposal_id  (measurement_proposal_id)
#  index_product_estimates_on_product_id               (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (measurement_proposal_id => measurement_proposals.id)
#  fk_rails_...  (product_id => products.id)
#
require 'test_helper'

class ProductEstimateTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
