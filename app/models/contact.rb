# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  category   :string
#  origin     :string
#  title      :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#

class Contact < ApplicationRecord
end
