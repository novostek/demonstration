# == Schema Information
#
# Table name: calculation_formulas
#
#  id          :uuid             not null, primary key
#  col_name    :string
#  default     :boolean
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

  def self.formula_default
    find_by(tax: false, default: true)
  end

  def calculate (areas, area_covered)
    begin
    calculator = Dentaku::Calculator.new
    area = Measurement.square_meter(areas)
    calculator.evaluate(self.formula, area: area, area_covered: area_covered).to_f
    rescue
      0.0
    end
  end
end
