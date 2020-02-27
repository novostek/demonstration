# == Schema Information
#
# Table name: signatures
#
#  id         :bigint           not null, primary key
#  file       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :integer
#
class Signature < ApplicationRecord
  mount_base64_uploader :file, DocumentFileUploader
end
