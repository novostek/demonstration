# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  active                 :boolean
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  worker_id              :uuid
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_worker_id             (worker_id)
#
# Foreign Keys
#
#  fk_rails_...  (worker_id => workers.id)
#

class User < ApplicationRecord
  belongs_to :worker, optional: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :validatable

  has_many :profile_users
  has_many :profiles, through: :profile_users
  has_many :profile_menus, through: :profiles
  has_many :menus, through: :profile_menus

  #Métdo que retorna o stats do usuario
  def usuario_ativo?
    self.active
  end

  #Método que verifica se o usuário está ativo
  def active_for_authentication?
    super && usuario_ativo?
  end

end
