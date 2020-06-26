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

class Product < ApplicationRecord
  mount_uploader :photo, DocumentFileUploader
  belongs_to :product_category, optional: true
  belongs_to :calculation_formula, optional: true
  belongs_to :supplier, optional: true

  has_many :products, :class_name => 'ProductSuggestion', :foreign_key => 'suggestion_id'
  has_many :product_suggestions, :class_name => 'ProductSuggestion', :foreign_key =>  'product_id'
  has_many :suggestions, through: :product_suggestions
  has_many :product_schedules
  has_many :schedules, through: :product_schedules, dependent: :destroy

  accepts_nested_attributes_for :product_schedules
  accepts_nested_attributes_for :schedules

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
    all.where(active: true).map{|a| [a.name,a.id]}
  end

end
