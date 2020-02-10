# == Schema Information
#
# Table name: suppliers
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Supplier < ApplicationRecord


  #Método que retorna o nome do supplier
  def to_s
    self.name
  end

  #Método que retorna um array dos objetos para usar nos combos
  def self.to_select
    all.map{|a| [a.name,a.id]}
  end
end
