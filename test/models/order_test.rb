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

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
