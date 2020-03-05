# == Schema Information
#
# Table name: documents
#
#  id          :bigint           not null, primary key
#  data        :text
#  description :text
#  doc_type    :string
#  name        :string
#  sub_type    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
