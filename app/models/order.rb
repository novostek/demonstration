# == Schema Information
#
# Table name: orders
#
#  id            :uuid             not null, primary key
#  bpmn_instance :string
#  code          :string
#  end_at        :datetime
#  photos        :json
#  start_at      :datetime
#  status        :string
#  total_cost    :decimal(, )
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Order < ApplicationRecord

  mount_uploaders :photos, DocumentFileUploader
  has_many :estimates
  has_many :product_estimates, through: :estimates
  has_many :purchases
  has_many :product_purchases, through: :purchases
  before_create :set_code
  has_many :transactions, -> { where origin: :Order }

  has_many :notes, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id

  has_many :schedules, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :labor_costs, through: :schedules
  has_one :current_estimate, ->{where current: true}, class_name: "Estimate"

  accepts_nested_attributes_for :transactions, reject_if: :all_blank, allow_destroy: true

  extend Enumerize

  enumerize :status, in: [:new, :finished, :cancelled, :awaiting_change_approval, :change_approved], predicates: true

  def reject_payment attributes
    attributes['value'].blank?
  end

  def as_json(options = {})
    s = super(options)
    s[:product_estimates] = self.get_current_estimate.product_estimates.distinct(:id)
    # s[:measurement_proposals] = self.measurement_areas.measurement_proposals
    s
  end

  def to_s
    self.code
  end

  def get_current_estimate
    self.estimates.where(current: true).last
  end

  def set_code
    order = Order.last
    if order.present?
      self.code = order[:code].to_i + 1
    else
      self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
    end
  end

  def get_taxes
    purchases.map { |purchase| purchase.product_purchases.where(:tax => true).map { |product| {
      :name => product.custom_title,
      :value => product.value.to_f
    } } }
  end

  def self.get_new_orders_count
    where("created_at > now() - interval '30 day' AND status = 'new'").count
  end

  def self.get_finished_orders_count
    where("created_at > now() - interval '30 day'  AND status = 'finished'").count
  end

  def self.get_cancelled_orders_count
    where("created_at > now() - interval '30 day'  AND status = 'cancelled'").count
  end

  def self.get_latest_orders limit
    all.order(id: :desc).limit(limit)
  end

  def get_customer_name
    self.current_estimate.customer.name
  end

  def get_order_value
    self.product_purchases.sum(:value).to_f
  end
end