# == Schema Information
#
# Table name: public.clients
#
#  id          :bigint           not null, primary key
#  name        :string
#  tenant_name :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
