# == Schema Information
#
# Table name: contacts
#
#  id         :uuid             not null, primary key
#  category   :string
#  data       :json
#  main       :boolean
#  origin     :string
#  title      :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :uuid
#

require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
