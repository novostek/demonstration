# == Schema Information
#
# Table name: menus
#
#  id         :uuid             not null, primary key
#  active     :boolean
#  ancestry   :string
#  icon       :string
#  name       :string
#  position   :integer
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_menus_on_ancestry  (ancestry)
#

require 'test_helper'

class MenuTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
