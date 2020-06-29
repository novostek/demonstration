class AddCardToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :square_card_id, :string
  end
end
