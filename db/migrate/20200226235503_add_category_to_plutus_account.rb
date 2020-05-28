class AddCategoryToPlutusAccount < ActiveRecord::Migration[6.0]
  def change
    add_reference :plutus_accounts, :transaction_category, null: false, foreign_key: true, type: :uuid
  end
end
