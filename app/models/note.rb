# == Schema Information
#
# Table name: notes
#
#  id          :uuid             not null, primary key
#  origin      :string           not null
#  private     :boolean
#  public_note :boolean
#  text        :text             not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  origin_id   :uuid             not null
#

class Note < ApplicationRecord
end
