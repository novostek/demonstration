class AddSquareDataToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :square_data, :json
  end
end
