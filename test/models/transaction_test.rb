# == Schema Information
#
# Table name: transactions
#
#  id                      :uuid             not null, primary key
#  bpm_instance            :string
#  category                :string
#  due                     :date
#  effective               :datetime
#  email                   :string
#  origin                  :string
#  payment_method          :string
#  square_data             :json
#  status                  :string
#  value                   :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_id                :uuid
#  origin_id               :string
#  purchase_id             :uuid
#  square_card_id          :string
#  transaction_account_id  :uuid
#  transaction_category_id :uuid
#
# Indexes
#
#  index_transactions_on_order_id                 (order_id)
#  index_transactions_on_purchase_id              (purchase_id)
#  index_transactions_on_transaction_account_id   (transaction_account_id)
#  index_transactions_on_transaction_category_id  (transaction_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (purchase_id => purchases.id)
#  fk_rails_...  (transaction_account_id => transaction_accounts.id)
#  fk_rails_...  (transaction_category_id => transaction_categories.id)
#
require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
