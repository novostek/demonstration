class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions, id: :uuid do |t|
      t.string :category
      t.references :transaction_category, foreign_key: true, type: :uuid
      t.references :transaction_account, foreign_key: true, type: :uuid
      t.references :order, foreign_key: true, type: :uuid
      t.string :origin
      t.date :due
      t.datetime :effective
      t.decimal :value
      t.string :bpm_instance

      t.timestamps
    end
  end
end
