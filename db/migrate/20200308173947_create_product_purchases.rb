class CreateProductPurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :product_purchases, id: :uuid do |t|
      t.references :product, foreign_key: true, type: :uuid
      t.references :purchase, null: false, foreign_key: true, type: :uuid
      t.decimal :unity_value
      t.decimal :quantity
      t.decimal :value
      t.string :status
      t.string :custom_title

      t.timestamps
    end
  end
end
