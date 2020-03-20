# == Schema Information
#
# Table name: orders
#
#  id            :bigint           not null, primary key
#  bpmn_instance :string
#  code          :string
#  end_at        :datetime
#  start_at      :datetime
#  status        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Order < ApplicationRecord
  has_many :estimates
  has_many :product_estimates, through: :estimates
  has_many :purchases
  has_many :product_purchases, through: :purchases
  before_create :set_code
  has_many :transactions

  has_many :notes, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id

  has_many :schedules, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id
  has_many :labor_costs, through: :schedules

  accepts_nested_attributes_for :transactions, reject_if: :all_blank, allow_destroy: true

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
    self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
  end
end
