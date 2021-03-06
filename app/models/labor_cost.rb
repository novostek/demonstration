# == Schema Information
#
# Table name: labor_costs
#
#  id          :uuid             not null, primary key
#  date        :date
#  status      :string
#  value       :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  schedule_id :uuid             not null
#  worker_id   :uuid             not null
#
# Indexes
#
#  index_labor_costs_on_schedule_id  (schedule_id)
#  index_labor_costs_on_worker_id    (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (schedule_id => schedules.id)
#  fk_rails_...  (worker_id => workers.id)
#
class LaborCost < ApplicationRecord
  belongs_to :worker
  belongs_to :schedule, optional: true
  has_one :order, through: :schedule

  extend Enumerize

  enumerize :status, in: [:paid, :pendent], predicates: true, default: :pendent

  has_many :notes, -> { where origin: :LaborCost }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :LaborCost }, primary_key: :id, foreign_key: :origin_id

  after_save :update_order_total_cost
  after_save :set_transaction

  #Método que atualiza o total dos custos da order
  def update_order_total_cost
    self.order.total_cost = self.order.product_purchases.sum(:value) + self.order.labor_costs.sum(:value)
    self.order.save
  end

  def set_transaction
    transaction = Transaction.find_or_initialize_by(origin: 'LaborCost', origin_id: self.id)
    transaction.order_id = Schedule.find(self.schedule_id).origin_id
    transaction.status = self.status == 'paid' ? 'paid' : 'pendent'
    transaction.value = self.value
    transaction.effective = self.status == 'paid' ? Time.now : nil
    transaction.save
  end
end
