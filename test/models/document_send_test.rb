# == Schema Information
#
# Table name: document_sends
#
#  id         :bigint           not null, primary key
#  data       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#
require 'test_helper'

class DocumentSendTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
