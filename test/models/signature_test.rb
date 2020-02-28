# == Schema Information
#
# Table name: signatures
#
#  id         :bigint           not null, primary key
#  file       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#
require 'test_helper'

class SignatureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
