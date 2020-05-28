# == Schema Information
#
# Table name: product_categories
#
#  id          :uuid             not null, primary key
#  color       :string
#  description :text
#  name        :string
#  namespace   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
