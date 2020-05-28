# == Schema Information
#
# Table name: document_custom_fields
#
#  id          :uuid             not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  document_id :uuid             not null
#
# Indexes
#
#  index_document_custom_fields_on_document_id  (document_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => documents.id)
#
class DocumentCustomField < ApplicationRecord
  belongs_to :document
  before_save :tolower

  def tolower
    self.name = self.name.downcase
  end
end
