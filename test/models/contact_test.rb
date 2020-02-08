# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  category   :string
#  origin     :string
#  title      :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
