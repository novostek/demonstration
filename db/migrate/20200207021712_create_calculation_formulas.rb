class CreateCalculationFormulas < ActiveRecord::Migration[6.0]
  def change
    create_table :calculation_formulas, id: :uuid do |t|
      t.string :name
      t.string :formula
      t.string :description
      t.boolean :tax
      t.string :namespace

      t.timestamps
    end
  end
end
