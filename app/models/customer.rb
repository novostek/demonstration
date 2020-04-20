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
  has_many :estimates, through: :leads

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

  def self.search_by_email email
    @customers = Customer.joins(:contacts).where("contacts.data->>'email' LIKE ? AND contacts.category = 'email'", "#{email}%")
  end

  def as_json(options = {})
    s = super(options)
    address = self.contacts.where(category: :address, main:true).last
    s[:contacts] = self.contacts
    s[:main_phone] = self.contacts.where(category: :phone, main:true).last.present? ? self.contacts.where(category: :phone, main:true).last.data["phone"] : ""
    s[:main_email] = self.contacts.where(category: :email, main:true).last.present? ? self.contacts.where(category: :email, main:true).last.data["email"] : ""
    s[:main_address] = address.present? ? address.data["address"] : ""
    s[:main_state] = address.present? ? address.data["state"] : ""
    s[:main_city] = address.present? ? address.data["city"] : ""
    s[:main_zipcode] = address.present? ? address.data["zipcode"] : ""
    s
  end

  def get_main_email
    begin
      self.contacts.where(category: :email, main:true).first
    rescue
      nil
    end
  end

  def get_main_phone
    begin
      self.contacts.where(category: :phone, main:true).first
    rescue
      nil
    end
  end

  def get_main_address
    begin
      self.contacts.where(category: :address, main:true).first
    rescue
      nil
    end
  end

  def get_main_email_f
    begin
      self.contacts.where(category: :email, main:true).first.data["email"]
    rescue
      nil
    end
  end

  def get_main_phone_f
    begin
      self.contacts.where(category: :phone, main:true).first.data["phone"]
    rescue
      nil
    end
  end

  def get_main_address_f
    begin
      address = self.contacts.where(category: :address, main:true).first.data
      "#{address['address']}, #{address['city']}, #{address['state']}, #{address['zipcode']}"
    rescue
      nil
    end
  end


end
