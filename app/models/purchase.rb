# == Schema Information
#
# Table name: purchases
#
#  id           :bigint           not null, primary key
#  bpm_instance :string
#  status       :string
#  value        :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :bigint           not null
#  supplier_id  :bigint
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
class Purchase < ApplicationRecord
  belongs_to :order
  belongs_to :supplier, optional: true
  has_many :product_purchases
  has_many :notes, -> { where origin: :Purchase }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Purchase }, primary_key: :id, foreign_key: :origin_id

  def as_json(options = {})
    s = super(options)
    s[:product_purchases] = self.product_purchases
    s
  end

  def get_products tax
    product_purchases.where(:tax => tax)
  end
end
