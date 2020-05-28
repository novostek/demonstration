# == Schema Information
#
# Table name: public.clients
#
#  id           :uuid             not null, primary key
#  code         :string
#  company_name :string
#  email        :string
#  name         :string
#  pwd          :string
#  tenant_name  :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
