# == Schema Information
#
# Table name: schedules
#
#  id            :bigint           not null, primary key
#  bpmn_instance :string
#  category      :string
#  color         :string
#  description   :text
#  end_at        :datetime
#  hour_cost     :decimal(, )
#  mail_sent     :boolean
#  origin        :string
#  send_mail     :boolean
#  start_at      :datetime
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  origin_id     :integer
#  worker_id     :bigint           not null
#
# Indexes
#
#  index_schedules_on_worker_id  (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (worker_id => workers.id)
#

class Schedule < ApplicationRecord
  belongs_to :worker
  has_one :labor_cost, dependent: :destroy
  has_one :order,  primary_key: :origin_id, foreign_key: :id


  after_save :set_labor_cost, if: :from_order?
  before_create :set_mail_sent

  #Método que seta como false a flag mail_sent que indica se o email foi enviado
  def set_mail_sent
    self.mail_sent = false
  end


  def from_order?
    self.origin == "Order"
  end

  #método que cria e atualiza o Labor Cost do schedule
  def set_labor_cost
    cost = LaborCost.find_or_create_by(schedule_id: self.id)
    cost.worker = self.worker
    cost.date = self.start_at.to_date
    cost.value = (self.hour_cost || 0) *  (self.end_at - self.start_at) / 1.hour  #(self.worker.time_value || 0) *  (self.end_at - self.start_at) / 1.hour
    cost.save
  end

  def self.new_schedule object

    begin
      schedule = self.find_or_create_by( origin_id: object[:origin_id], worker_id: object[:worker_id], id: object[:schedule_id])
      schedule.title = object[:title]
      schedule.category = object[:category]
      schedule.description = object[:description]
      schedule.start_at = object[:start_at]
      schedule.end_at = object[:end_at] || schedule.start_at + 30.minutes
      schedule.color = object[:color]
      schedule.worker_id = object[:worker_id]
      schedule.origin = object[:origin]
      schedule.origin_id = object[:origin_id]
      schedule.send_mail  = object[:send_mail]
      if schedule.origin == "Order"
        schedule.hour_cost = schedule.worker.time_value
      end

      schedule.save
    rescue StandardError => e
      return {
        :error => e.message,
        :trace => e.inspect
      }
    else
      return {
        :schedule => schedule
      }
    end
  end
end
