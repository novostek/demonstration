# == Schema Information
#
# Table name: profiles
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  permissions :json
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
