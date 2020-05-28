class CreatePurchases < ActiveRecord::Migration[6.0]
  def change
    create_table :purchases, id: :uuid do |t|
      t.references :order, null: false, foreign_key: true, type: :uuid
      t.references :supplier, foreign_key: true, type: :uuid
      t.decimal :value
      t.string :status
      t.string :bpm_instance

      t.timestamps
    end
  end
end
