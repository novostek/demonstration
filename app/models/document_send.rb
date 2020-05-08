# == Schema Information
#
# Table name: document_sends
#
#  id         :bigint           not null, primary key
#  data       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#
class DocumentSend < ApplicationRecord
end
