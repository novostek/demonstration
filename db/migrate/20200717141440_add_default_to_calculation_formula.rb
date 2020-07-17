class AddDefaultToCalculationFormula < ActiveRecord::Migration[6.0]
  def change
    add_column :calculation_formulas, :default, :boolean
    add_column :calculation_formulas, :col_name, :string
  end
end
