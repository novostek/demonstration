class CreateProductPurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :product_purchases do |t|
      t.references :product, foreign_key: true
      t.references :purchase, null: false, foreign_key: true
      t.decimal :unity_value
      t.decimal :quantity
      t.decimal :value
      t.string :status
      t.string :custom_title

      t.timestamps
    end
  end
end
