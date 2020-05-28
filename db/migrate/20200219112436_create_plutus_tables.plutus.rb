# This migration comes from plutus (originally 20160422010135)
class CreatePlutusTables < ActiveRecord::Migration[6.0]
  def change
    create_table :plutus_accounts, id: :uuid do |t|
      t.string :name
      t.string :type
      t.boolean :contra, default: false

      t.timestamps
    end
    add_index :plutus_accounts, [:name, :type]

    create_table :plutus_entries, id: :uuid do |t|
      t.string :description
      t.date :date
      t.integer :commercial_document_id
      t.string :commercial_document_type

      t.timestamps
    end
    add_index :plutus_entries, :date
    add_index :plutus_entries, [:commercial_document_id, :commercial_document_type], :name => "index_entries_on_commercial_doc"

    create_table :plutus_amounts, id: :uuid do |t|
      t.string :type
      t.references :account, type: :uuid
      t.references :entry, type: :uuid
      t.decimal :amount, :precision => 20, :scale => 10
    end
    add_index :plutus_amounts, :type
    add_index :plutus_amounts, [:account_id, :entry_id]
    add_index :plutus_amounts, [:entry_id, :account_id]
  end
end
