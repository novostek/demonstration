# == Schema Information
#
# Table name: leads
#
#  id          :uuid             not null, primary key
#  code        :string
#  date        :datetime
#  description :text
#  email       :string
#  phone       :string
#  status      :string
#  via         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :uuid             not null
#
# Indexes
#
#  index_leads_on_code         (code)
#  index_leads_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#

require 'test_helper'

class LeadTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
