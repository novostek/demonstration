# == Schema Information
#
# Table name: customers
#
#  id           :bigint           not null, primary key
#  birthdate    :date
#  bpm_instance :string
#  category     :string
#  code         :string
#  name         :string
#  since        :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  document_id  :string
#

class Customer < ApplicationRecord

  has_many :notes, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id
  has_many :contacts, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id
  has_many :document_files, -> { where origin: :Customer }, primary_key: :id, foreign_key: :origin_id
  has_many :leads

  accepts_nested_attributes_for :notes, allow_destroy: true
  accepts_nested_attributes_for :contacts, allow_destroy: true
  accepts_nested_attributes_for :document_files, allow_destroy: true

  extend Enumerize

  enumerize :category, in: [:company, :person],predicates: true

  validates :name, :category, presence: true

  before_save :set_code

  def to_s
    self.name
  end

  #Método que seta o code caso seja vazio
  def set_code
    if self.code.blank?
      self.code = self.name.parameterize
    end
  end


  def nome_categoria
    "#{self.name} - #{self.category}"
  end

  def self.search_by_phone phone
    @customers = Customer.joins(:contacts).where("contacts.data->>'phone' LIKE ? AND contacts.category = 'phone'", "#{phone}%")
  end

  def as_json(options = {})
    s = super(options)
    s[:contacts] = self.contacts
    s
  end


end
