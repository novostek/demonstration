# == Schema Information
#
# Table name: product_purchases
#
#  id           :uuid             not null, primary key
#  custom_title :string
#  quantity     :decimal(, )
#  status       :string
#  tax          :boolean          default(FALSE)
#  unity_value  :decimal(, )
#  value        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  product_id   :uuid
#  purchase_id  :uuid             not null
#
# Indexes
#
#  index_product_purchases_on_product_id   (product_id)
#  index_product_purchases_on_purchase_id  (purchase_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (purchase_id => purchases.id)
#
require 'test_helper'

class ProductPurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
