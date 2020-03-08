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

  
  def to_s
    self.code
  end


  def set_code
    self.code = "#{Time.now.strftime('%Y')}000000".to_i + 1
  end
end
