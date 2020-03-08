class AddFieldsToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :origin_id, :integer
    add_column :transactions, :payment_method, :string
  end
end
