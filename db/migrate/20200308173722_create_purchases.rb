class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases do |t|
      t.references :order, null: false, foreign_key: true
      t.references :supplier, foreign_key: true
      t.decimal :value
      t.string :status
      t.string :bpm_instance

      t.timestamps
    end
  end
end
