# == Schema Information
#
# Table name: document_sends
#
#  id         :uuid             not null, primary key
#  data       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :uuid
#
class DocumentSend < ApplicationRecord
end
