# == Schema Information
#
# Table name: customers
#
#  id              :uuid             not null, primary key
#  birthdate       :date
#  bpm_instance    :string
#  category        :string
#  code            :string
#  name            :string
#  since           :date
#  temporary_email :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  document_id     :string
#  square_id       :string
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

  after_create :create_customer_square

  #Método que cria o customer na square
  def create_customer_square
    if Setting.get_value("square_oauth_access_token").present?
      SquareApi.create_customer(self)
    end
  end

  #Método que cria os customers na square para aqueles que ainda não possuem
  def self.create_square_customers
    Client.all.each do |c|
      Apartment::Tenant.switch(c.tenant_name) do
        Customer.where(square_id: nil).each do |customer|
          customer.create_customer_square
        end
      end
    end
  end

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

  def set_customer_by_phone(phone)
    phone
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

  def self.count_new_customers
    where("created_at > now() - interval '30 day'").count
  end

  def self.get_recent_customers limit
    all.order(id: :desc).limit(limit)
  end

  def get_cards
    begin
      dados = SquareApi.get_customer(self.square_id)
      cards = dados.body.customer[:cards] || []
    rescue
      cards = []
    end

    cards
  end

  def delete_customer_card(card_id)
    result, result_json = SquareApi.delete_customer_card(self.square_id, card_id)

    result
  end
end
