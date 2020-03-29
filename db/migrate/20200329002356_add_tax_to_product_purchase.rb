class AddTaxToProductPurchase < ActiveRecord::Migration[6.0]
  def change
    add_column :product_purchases, :tax, :boolean, :default => false
  end
end
