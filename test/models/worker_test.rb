# == Schema Information
#
# Table name: workers
#
#  id          :bigint           not null, primary key
#  name        :string
#  photo       :text
#  document_id :string
#  categories  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class WorkerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
