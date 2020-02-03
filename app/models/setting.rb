class Setting < ApplicationRecord
  validates :namespace, uniqueness: true, presence: true

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
end
