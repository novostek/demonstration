class CreateProductSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :product_suggestions do |t|
      t.references :product
      t.references :suggestion
    end

    add_foreign_key :product_suggestions, :products, column: :product_id, primary_key: :id
    add_foreign_key :product_suggestions, :products, column: :suggestion_id, primary_key: :id
  end
end
