# == Schema Information
#
# Table name: product_suggestions
#
#  id            :bigint           not null, primary key
#  product_id    :bigint
#  suggestion_id :bigint
#
# Indexes
#
#  index_product_suggestions_on_product_id     (product_id)
#  index_product_suggestions_on_suggestion_id  (suggestion_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (suggestion_id => products.id)
#
require 'test_helper'

class ProductSuggestionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
