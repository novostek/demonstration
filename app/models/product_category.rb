# == Schema Information
#
# Table name: product_categories
#
#  id          :uuid             not null, primary key
#  color       :string
#  description :text
#  name        :string
#  namespace   :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class ProductCategory < ApplicationRecord


  before_save :slug_namespace


  #Método que retorna o nome do produto
  def to_s
    self.name
  end

  #Método que retorna um array dos objetos para utilizar em um select
  def self.to_select
    all.map{|a| [a,a.id]}
  end


  #Método que executa slugfy para o namespace caso seja vazio
  def slug_namespace
    if self.namespace.blank?
      self.namespace = self.name.parameterize
    end
  end
end
