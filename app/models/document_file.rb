# == Schema Information
#
# Table name: document_files
#
#  id          :uuid             not null, primary key
#  description :text
#  esign       :boolean
#  esign_data  :json
#  file        :text
#  origin      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  origin_id   :uuid
#

class DocumentFile < ApplicationRecord
  mount_uploader :file, DocumentFileUploader

  validates :title, :origin, :origin_id, presence: true
end
