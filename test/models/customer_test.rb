# == Schema Information
#
# Table name: customers
#
#  id              :uuid             not null, primary key
#  birthdate       :date
#  bpm_instance    :string
#  category        :string
#  code            :string
#  name            :string
#  since           :date
#  temporary_email :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  document_id     :string
#  square_id       :string
#

require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
