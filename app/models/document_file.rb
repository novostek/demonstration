# == Schema Information
#
# Table name: document_files
#
#  id          :bigint           not null, primary key
#  description :text
#  esign       :boolean
#  esign_data  :json
#  file        :text
#  origin      :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  origin_id   :integer
#

class DocumentFile < ApplicationRecord
  mount_uploader :file, DocumentFileUploader

  validates :title, :origin, :origin_id, presence: true
end
