# == Schema Information
#
# Table name: document_files
#
#  id          :uuid             not null, primary key
#  description :text
#  esign       :boolean
#  esign_data  :json
#  file        :text
#  origin      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  origin_id   :uuid
#

require 'test_helper'

class DocumentFileTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
