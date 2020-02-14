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
end
