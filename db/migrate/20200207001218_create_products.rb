class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :uuid
      t.text :details
      t.references :product_category, null: false, foreign_key: true
      t.decimal :customer_price
      t.decimal :cost_price
      t.decimal :area_covered
      t.boolean :tax
      t.string :bpm_purchase

      t.timestamps
    end
  end
end
