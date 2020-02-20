# == Schema Information
#
# Table name: workers
#
#  id          :bigint           not null, primary key
#  name        :string
#  photo       :text
#  document_id :string
#  categories  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Worker < ApplicationRecord
  mount_uploader :photo, DocumentFileUploader

  validates :name, :categories, presence: true

  extend Enumerize

  enumerize :categories, in: [:employee, :contractor]

  has_many :notes, -> { where origin: :Worker }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Worker }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Worker }, primary_key: :id, foreign_key: :origin_id

  accepts_nested_attributes_for :notes, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :document_files, allow_destroy: true

  def to_s
    self.name
  end

  def self.to_select
    all.map{|a| [a.name,a.id]}
  end
end
