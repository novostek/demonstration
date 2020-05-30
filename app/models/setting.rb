# == Schema Information
#
# Table name: settings
#
#  id         :uuid             not null, primary key
#  namespace  :string
#  value      :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Setting < ApplicationRecord
  validates :namespace, uniqueness: true, presence: true
  before_validation :format_value

  def to_s
    self.namespace
  end

  def self.get_value(namespace)
    s = Setting.find_by_namespace(namespace)
    if s.present?
      return s.value['value']
    end
    ''
  end

  def format_value
    if self.value.class == String
      self.value = JSON.parse(self.value)
    end
  end

  def self.logo_object
    DocumentFile.where(origin: "Logo", origin_id: '1e1e3f7b-92f7-4da4-8894-1bfbfb24d39b').first
  end

  def self.banner_object
    DocumentFile.where(origin: "Banner", origin_id: '893d3e36-2542-4fb3-bb70-754ddb97a64b').first
  end

  def self.logo
    d = logo_object
    if d.present?
      return d.file.url.gsub('https','http')
    end
    "/woffice.svg"
  end

  def self.banner
    d = banner_object
    if d.present?
      return d.file.url.gsub('https','http')
    end
    "/woffice.svg"
  end

  def self.url
    s = Setting.find_by_namespace('url_app')
    if s.present?
      return s.value['value']
    end
    "http://woffice.app"
  end
end
