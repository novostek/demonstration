# == Schema Information
#
# Table name: document_custom_fields
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  document_id :bigint           not null
#
# Indexes
#
#  index_document_custom_fields_on_document_id  (document_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
require 'test_helper'

class DocumentCustomFieldTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
