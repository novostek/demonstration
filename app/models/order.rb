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
  before_create :set_code
  has_many :transactions

  has_many :schedules, -> { where origin: :Order }, primary_key: :id, foreign_key: :origin_id

  accepts_nested_attributes_for :transactions, reject_if: :all_blank, allow_destroy: true

  def to_s
    self.code
  end

  def get_current_estimate
    self.estimates.where(current: true).first
  end

  def set_code
    self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
  end
end
