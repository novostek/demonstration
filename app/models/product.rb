# == Schema Information
#
# Table name: products
#
#  id                     :bigint           not null, primary key
#  area_covered           :decimal(, )
#  bpm_purchase           :string
#  cost_price             :decimal(, )
#  customer_price         :decimal(, )
#  details                :text
#  name                   :string
#  photo                  :text
#  tax                    :boolean
#  uuid                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  calculation_formula_id :bigint           not null
#  product_category_id    :bigint           not null
#  supplier_id            :bigint           not null
#
# Indexes
#
#  index_products_on_calculation_formula_id  (calculation_formula_id)
#  index_products_on_product_category_id     (product_category_id)
#  index_products_on_supplier_id             (supplier_id)
#
# Foreign Keys
#
#  fk_rails_...  (calculation_formula_id => calculation_formulas.id)
#  fk_rails_...  (product_category_id => product_categories.id)
#  fk_rails_...  (supplier_id => suppliers.id)
#

class Product < ApplicationRecord
  mount_uploader :photo, DocumentFileUploader
  belongs_to :product_category, optional: true
  belongs_to :calculation_formula, optional: true
  belongs_to :supplier, optional: true

  validates :name, :uuid, :customer_price, :cost_price, :area_covered, :calculation_formula_id, presence: true
end
