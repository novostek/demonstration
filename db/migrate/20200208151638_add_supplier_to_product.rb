class AddSupplierToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :supplier, null: false, foreign_key: true, type: :uuid
  end
end
