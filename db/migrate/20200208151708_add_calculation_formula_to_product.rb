class AddCalculationFormulaToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :calculation_formula, null: false, foreign_key: true, type: :uuid
  end
end
