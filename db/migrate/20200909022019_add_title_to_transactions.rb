class AddTitleToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :title, :string
  end
end
