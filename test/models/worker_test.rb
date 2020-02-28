# == Schema Information
#
# Table name: workers
#
#  id          :bigint           not null, primary key
#  categories  :string
#  name        :string
#  photo       :text
#  time_value  :decimal(, )
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  document_id :string
#

require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
