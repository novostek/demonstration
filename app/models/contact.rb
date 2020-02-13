# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  category   :string
#  data       :json
#  origin     :string
#  title      :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#

class Contact < ApplicationRecord

  extend Enumerize

  enumerize :category, in: [:phone, :address, :email], predicates: true
end
