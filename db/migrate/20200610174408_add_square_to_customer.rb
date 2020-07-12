class AddSquareToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :square_id, :string
  end
end
