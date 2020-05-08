class AddTaxpayerToEstimate < ActiveRecord::Migration[6.0]
  def change
    add_column :estimates, :taxpayer, :string
    add_index :estimates, :taxpayer
  end
end
