# == Schema Information
#
# Table name: calculation_formulas
#
#  id          :uuid             not null, primary key
#  col_name    :string
#  default     :boolean
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
