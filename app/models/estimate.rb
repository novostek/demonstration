# == Schema Information
#
# Table name: estimates
#
#  id                 :bigint           not null, primary key
#  bpmn_instance      :string
#  category           :string           not null
#  code               :string           not null
#  current            :boolean
#  description        :text             not null
#  latitude           :decimal(, )      not null
#  link               :text
#  location           :string           not null
#  longitude          :decimal(, )      not null
#  price              :decimal(, )
#  status             :string           not null
#  tax                :decimal(, )
#  taxpayer           :string
#  title              :string           not null
#  total              :decimal(, )      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  lead_id            :bigint
#  order_id           :bigint
#  sales_person_id    :bigint
#  tax_calculation_id :bigint
#
# Indexes
#
#  index_estimates_on_lead_id             (lead_id)
#  index_estimates_on_order_id            (order_id)
#  index_estimates_on_sales_person_id     (sales_person_id)
#  index_estimates_on_tax_calculation_id  (tax_calculation_id)
#  index_estimates_on_taxpayer            (taxpayer)
#
# Foreign Keys
#
#  fk_rails_...  (lead_id => leads.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (sales_person_id => workers.id)
#  fk_rails_...  (tax_calculation_id => calculation_formulas.id)
#

class Estimate < ApplicationRecord
  after_initialize :initialize_code, if: :new_record?

  alias_attribute :tax_calculation, :calculation_formula

  belongs_to :worker, optional: true
  belongs_to :order, optional: true
  belongs_to :lead, optional: true
  has_one :customer, through: :lead
  has_one :worker, primary_key: :sales_person_id, foreign_key: :id
  has_one :calculation_formula, primary_key: :tax_calculation_id, foreign_key: :id

  has_many :signatures, -> { where origin: :Estimate }, primary_key: :id, foreign_key: :origin_id
  has_many :measurement_areas, dependent: :destroy
  has_many :measurements, through: :measurement_areas
  has_many :measurement_proposals, through: :measurement_areas
  has_many :product_estimates, through: :measurement_proposals

  has_many :notes, -> { where origin: :Estimate }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Estimate }, primary_key: :id, foreign_key: :origin_id

  # has_many :measurement, through: :measurement_areas

  accepts_nested_attributes_for :measurement_areas, reject_if: :reject_measurement_areas, allow_destroy: true
  # accepts_nested_attributes_for :measurement, reject_if: :all_blank, allow_destroy: true

  has_many :schedules, -> { where origin: :Estimate }, primary_key: :id, foreign_key: :origin_id

  extend Enumerize

  enumerize :taxpayer, in: [:customer, :company], predicates: true
  enumerize :category, in: [:estimate, :change_order], predicates: true, default: :estimate
  enumerize :status, in: [:new, :waiting_approval, :ordered, :cancelled], predicates: true, default: :new

  def reject_measurement_areas attributes
    attributes['name'].blank? && attributes['description'].blank?
  end

  def get_total_value
    self.product_estimates.distinct(:id).sum(:value) - self.product_estimates.sum(:discount).to_f + self.tax.to_f
  end

  def get_subtotal
    self.product_estimates.distinct.joins(:product).sum(:value).to_f
  end

  def as_json(options = {})
    s = super(options)
    s[:measurement_areas] = self.measurement_areas
    s[:measurement_proposals] = self.measurement_proposals.distinct(:id)
    s[:lead] = self.lead
    # s[:measurement_proposals] = self.measurement_areas.measurement_proposals
    s
  end

  def initialize_code
    last_estimate = Estimate.last
    if last_estimate.present?
      self.code = last_estimate[:code].to_i + 1
    else
      self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
    end
  end

  def calculate_tax_values_for_customer
    calculator = Dentaku::Calculator.new
    sub_total = self.product_estimates.distinct.joins(:product).sum(:value)
    tax_products = self.product_estimates.joins(:product).where(products: {:tax => true}).sum(:value)
    sub_total_taxes = calculator.evaluate(self.calculation_formula.formula, total: tax_products)
    self.price = (sub_total + sub_total_taxes) - self.product_estimates.distinct.sum(:discount)
    self.tax = sub_total_taxes
    self.save
  end

  #Método que cria a order
  def create_order
    if !self.order.present?
      order = Order.new
      if order.save
        self.update(order_id: order.id, current: true)

        #cria os purchases
        self.product_estimates.each do |p|
          #verifica se o produto pertence ao catalogo
          if p.product.present?
            #begin
            product = p.product
            purchase = Purchase.find_or_create_by(order_id: order.id, supplier_id: product.supplier.id)
            pp = ProductPurchase.find_or_create_by(product: product, purchase: purchase)
            pp.unity_value =  product.cost_price
            pp.quantity =  p.quantity
            pp.value = pp.unity_value * pp.quantity
            pp.custom_title = p.custom_title
            pp.save
            # rescue
            #end

          else #custom products
            purchase = Purchase.find_or_create_by(order_id: order.id, supplier_id: nil)
            ProductPurchase.create(purchase: purchase, unity_value: p.unitary_value, quantity: p.quantity, value: p.value, custom_title: p.custom_title)
          end

        end
      end
    end
  end
end
