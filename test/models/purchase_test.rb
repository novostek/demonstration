# == Schema Information
#
# Table name: purchases
#
#  id           :uuid             not null, primary key
#  bpm_instance :string
#  status       :string
#  value        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :uuid             not null
#  supplier_id  :uuid
#
# Indexes
#
#  index_purchases_on_order_id     (order_id)
#  index_purchases_on_supplier_id  (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (supplier_id => suppliers.id)
#
require 'test_helper'

class PurchaseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
