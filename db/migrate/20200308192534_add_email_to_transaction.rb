class AddEmailToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :email, :string
  end
end
