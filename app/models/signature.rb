# == Schema Information
#
# Table name: signatures
#
#  id         :uuid             not null, primary key
#  file       :text
#  origin     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  origin_id  :uuid
#
class Signature < ApplicationRecord
  mount_base64_uploader :file, DocumentFileUploader

  def as_json(options = {})
    s = super(options)
    s[:link] = self.file.url
    s
  end

  def self.base64_to_file(base64_data)
    return base64_data unless base64_data.is_a? String

    start_regex = /data:image\/[a-z]{3,4};base64,/
    filename ||= SecureRandom.hex

    regex_result = start_regex.match(base64_data)
    if base64_data && regex_result
      start = regex_result.to_s
      tempfile = Tempfile.new(['signature', '.jpg'], Rails.root.join('public'))
      tempfile.binmode
      tempfile.write(Base64.decode64(base64_data[start.length..-1]))
      # uploaded_file = ActionDispatch::Http::UploadedFile.new(
      #     :tempfile => tempfile,
      #     :filename => "signature.jpg",
      #     :original_filename => "signature.jpg"
      # )

      tempfile
    else
      nil
    end
  end

end
