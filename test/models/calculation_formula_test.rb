# == Schema Information
#
# Table name: calculation_formulas
#
#  id          :bigint           not null, primary key
#  description :string
#  formula     :string
#  name        :string
#  namespace   :string
#  tax         :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class CalculationFormulaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
