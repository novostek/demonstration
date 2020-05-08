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
  before_save :slug_namespace

  #Método que retorna o nome da formula
  def to_s
    self.name
  end


  #Método que retorna um array dos objetos para usar nos combos
  def self.to_select
    all.map{|a| [a.name,a.id]}
  end

  def slug_namespace
    if self.namespace.blank?
      self.namespace = self.name.parameterize
    end
  end
end
