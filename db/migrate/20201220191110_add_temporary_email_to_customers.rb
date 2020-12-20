class AddTemporaryEmailToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :temporary_email, :string
  end
end
