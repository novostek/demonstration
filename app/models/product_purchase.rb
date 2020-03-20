# == Schema Information
#
# Table name: product_purchases
#
#  id           :bigint           not null, primary key
#  custom_title :string
#  quantity     :decimal(, )
#  status       :string
#  unity_value  :decimal(, )
#  value        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  product_id   :bigint
#  purchase_id  :bigint           not null
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
class ProductPurchase < ApplicationRecord
  belongs_to :product, optional: true
  belongs_to :purchase
  has_one :order, through: :purchase

  has_many :notes, -> { where origin: :ProductPurchase }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :ProductPurchase }, primary_key: :id, foreign_key: :origin_id

  extend Enumerize
  enumerize :status, in: [:requested, :buyed, :delivered, :returned],predicates: true

  def as_json(options = {})
    s = super(options)
    s[:product] = self.product
    s
  end
end
