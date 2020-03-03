class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :category
      t.references :transaction_category, foreign_key: true
      t.references :transaction_account, foreign_key: true
      t.references :order, foreign_key: true
      t.string :origin
      t.date :due
      t.datetime :effective
      t.decimal :value
      t.string :bpm_instance

      t.timestamps
    end
  end
end
