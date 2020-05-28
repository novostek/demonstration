class CreateProductSuggestions < ActiveRecord::Migration[6.0]
  def change
    create_table :product_suggestions, id: :uuid do |t|
      t.references :product, type: :uuid
      t.references :suggestion, type: :uuid
    end

    add_foreign_key :product_suggestions, :products, column: :product_id, primary_key: :id
    add_foreign_key :product_suggestions, :products, column: :suggestion_id, primary_key: :id
  end
end
