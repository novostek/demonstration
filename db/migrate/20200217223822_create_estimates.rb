class CreateEstimates < ActiveRecord::Migration[6.0]
  def change
    create_table :estimates, id: :uuid do |t|
      t.string :code, null: false
      t.string :title, null: false
      t.references :sales_person, foreign_key: { to_table: :workers }, type: :uuid
      t.string :status, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.decimal :latitude, null: false
      t.decimal :longitude, null: false
      t.string :category, null: false
      t.references :order, foreign_key: true, type: :uuid
      t.decimal :price
      t.decimal :tax
      t.references :tax_calculation, foreign_key: { to_table: :calculation_formulas }, type: :uuid
      t.references :lead, foreign_key: true, type: :uuid
      t.string :bpmn_instance
      t.boolean :current
      t.decimal :total, null: false

      t.timestamps
    end
  end
end
