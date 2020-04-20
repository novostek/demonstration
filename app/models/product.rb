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
#  supplier_id            :bigint
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

  has_many :products, :class_name => 'ProductSuggestion', :foreign_key => 'suggestion_id'
  has_many :product_suggestions, :class_name => 'ProductSuggestion', :foreign_key =>  'product_id'
  has_many :suggestions, through: :product_suggestions

  validates :name,  :customer_price, :cost_price, :area_covered, :calculation_formula_id, presence: true

  before_save :set_uuid

  require 'securerandom'

  #Método que retorna o nome do produto
  def to_s
    self.name
  end

  def set_uuid
    if self.uuid.blank?
      self.uuid =  SecureRandom.uuid
    end
  end

  def self.to_select
    all.map{|a| [a.name,a.id]}
  end

end
