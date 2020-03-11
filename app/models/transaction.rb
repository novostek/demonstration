# == Schema Information
#
# Table name: transactions
#
#  id                      :bigint           not null, primary key
#  bpm_instance            :string
#  category                :string
#  due                     :date
#  effective               :datetime
#  email                   :string
#  origin                  :string
#  payment_method          :string
#  square_data             :json
#  value                   :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  order_id                :bigint
#  origin_id               :integer
#  purchase_id             :bigint
#  transaction_account_id  :bigint
#  transaction_category_id :bigint
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
class Transaction < ApplicationRecord
  belongs_to :transaction_category, optional:  true
  belongs_to :transaction_account, optional:  true
  belongs_to :order, optional:  true

  extend Enumerize

  enumerize :payment_method, in: [:cash, :square_credit, :square_installments], predicates: true

  #validates :category, :effective, :value, presence: true
  
  after_create :send_square
  
  
  def send_square
    if self.payment_method.square_credit?
      checkout_status, checkout_data = SquareApi.create_checkout(self.order, self)
      if checkout_status
        DocumentMailer.with(link: checkout_data[:checkout][:checkout_page_url] , emails: "gabrielvash@gmail.com", order: self.order).send_square.deliver_now
      else
        redirect_to process_payment_customers_path
      end
    end
  end
end
