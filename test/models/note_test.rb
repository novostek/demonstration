# == Schema Information
#
# Table name: notes
#
#  id         :bigint           not null, primary key
#  origin     :string           not null
#  private    :boolean
#  text       :text             not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer          not null
#

require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
