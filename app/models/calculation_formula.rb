# == Schema Information
#
# Table name: calculation_formulas
#
#  id          :bigint           not null, primary key
#  description :string
#  formula     :string
#  name        :string
#  namespace   :string
#  tax         :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class CalculationFormula < ApplicationRecord

  #Método que retorna o nome da formula
  def to_s
    self.name
  end


  #Método que retorna um array dos objetos para usar nos combos
  def self.to_select
    all.map{|a| [a.name,a.id]}
  end
end
