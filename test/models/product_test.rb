# == Schema Information
#
# Table name: products
#
#  id                     :uuid             not null, primary key
#  active                 :boolean          default(TRUE)
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
#  calculation_formula_id :uuid             not null
#  product_category_id    :uuid             not null
#  supplier_id            :uuid             not null
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

require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
