# == Schema Information
#
# Table name: settings
#
#  id         :uuid             not null, primary key
#  namespace  :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
