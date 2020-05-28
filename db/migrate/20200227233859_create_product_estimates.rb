class CreateProductEstimates < ActiveRecord::Migration[6.0]
  def change
    create_table :product_estimates, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.string :custom_title
      t.text :notes
      t.decimal :unitary_value
      t.decimal :quantity
      t.decimal :discount
      t.decimal :value
      t.boolean :tax
      t.references :measurement_proposal, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
