# == Schema Information
#
# Table name: workers
#
#  id          :bigint           not null, primary key
#  name        :string
#  photo       :text
#  document_id :string
#  categories  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Worker < ApplicationRecord
  mount_uploader :photo, DocumentFileUploader

  validates :name, :categories, presence: true

  extend Enumerize

  enumerize :categories, in: [:employee, :contractor]
end
