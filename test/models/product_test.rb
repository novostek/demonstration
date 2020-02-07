# == Schema Information
#
# Table name: products
#
#  id                  :bigint           not null, primary key
#  area_covered        :decimal(, )
#  bpm_purchase        :string
#  cost_price          :decimal(, )
#  customer_price      :decimal(, )
#  details             :text
#  name                :string
#  tax                 :boolean
#  uuid                :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint           not null
#
# Indexes
#
#  index_products_on_product_category_id  (product_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_category_id => product_categories.id)
#

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
