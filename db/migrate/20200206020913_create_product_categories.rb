class CreateProductCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :product_categories do |t|
      t.string :name
      t.text :description
      t.string :color
      t.string :namespace

      t.timestamps
    end
  end
end
