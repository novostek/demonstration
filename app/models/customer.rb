# == Schema Information
#
# Table name: customers
#
#  id          :bigint           not null, primary key
#  name        :string
#  category    :string
#  document_id :string
#  since       :date
#  code        :string
#  birthdate   :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Customer < ApplicationRecord

  has_many :notes, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id

  accepts_nested_attributes_for :notes, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :document_files, allow_destroy: true

  extend Enumerize

  enumerize :category, in: [:company, :person]

  validates :name, :category, presence: true

  before_save :set_code


  #Método que seta o code caso seja vazio
  def set_code
    if self.code.blank?
      self.code = self.name.parameterize
    end
  end
end
