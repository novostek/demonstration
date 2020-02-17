class CreateEstimates < ActiveRecord::Migration[6.0]
  def change
    create_table :estimates do |t|
      t.string :code
      t.string :title
      t.references :worker, null: false, foreign_key: true
      t.string :status
      t.text :description
      t.string :location
      t.decimal :latitude
      t.decimal :longitude
      t.string :category
      t.references :order, null: false, foreign_key: true
      t.decimal :price
      t.decimal :tax
      t.references :tax_calculation, foreign_key: { to_table: :calculation_formula }
      t.references :lead, null: false, foreign_key: true
      t.string :bpmn_instance
      t.boolean :current
      t.decimal :total

      t.timestamps
    end
  end
end
