# == Schema Information
#
# Table name: transactions
#
#  id                      :bigint           not null, primary key
#  bpm_instance            :string
#  category                :string
#  due                     :date
#  effective               :datetime
#  origin                  :string
#  square_data             :json
#  value                   :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_id                :bigint
#  transaction_account_id  :bigint
#  transaction_category_id :bigint
#
# Indexes
#
#  index_transactions_on_order_id                 (order_id)
#  index_transactions_on_transaction_account_id   (transaction_account_id)
#  index_transactions_on_transaction_category_id  (transaction_category_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (transaction_account_id => transaction_accounts.id)
#  fk_rails_...  (transaction_category_id => transaction_categories.id)
#
class Transaction < ApplicationRecord
  belongs_to :transaction_category, optional:  true
  belongs_to :transaction_account, optional:  true
  belongs_to :order, optional:  true
end
