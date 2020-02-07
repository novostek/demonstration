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
