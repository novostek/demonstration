# == Schema Information
#
# Table name: customers
#
#  id          :bigint           not null, primary key
#  name        :string
#  category    :string
#  document_id :string
#  since       :date
#  code        :string
#  birthdate   :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
