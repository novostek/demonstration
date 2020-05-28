class AddPurchaseToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :purchase, null: true, foreign_key: true, type: :uuid
  end
end
