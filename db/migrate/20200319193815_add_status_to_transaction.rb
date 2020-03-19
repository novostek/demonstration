class AddStatusToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :status, :string
  end
end
