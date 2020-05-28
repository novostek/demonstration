# == Schema Information
#
# Table name: profiles
#
#  id          :uuid             not null, primary key
#  description :string
#  name        :string
#  permissions :json
#  status      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Profile < ApplicationRecord

  has_many :profile_menus
  has_many :profile_users
  has_many :users, through: :profile_users

  validates :name, presence: true

  before_create :set_status
  #has_many :perfil_menus
  #has_many :perfil_users


  #Método que seta o status inicial do perfil
  def set_status
    self.status = true
  end


  #Método que retorna o nome do perfil
  def to_s
    self.name
  end

  #Método que retorna um array dos perfis para utilização em selects
  def self.to_select
    where(status: true).map{|a| [a.name,a.id]}
  end

end
