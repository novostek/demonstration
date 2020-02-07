# == Schema Information
#
# Table name: document_files
#
#  id                :bigint           not null, primary key
#  title             :string
#  file              :text
#  origin            :string
#  origin_id         :integer
#  esign             :boolean
#  esign_data        :json
#  photo             :string
#  photo_date        :date
#  photo_description :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class DocumentFile < ApplicationRecord
  mount_uploader :file, DocumentFileUploader

  validates :title, :origin, :origin_id, presence: true
end
