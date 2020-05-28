class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads, id: :uuid do |t|
      t.references :customer, null: false, foreign_key: true, type: :uuid
      t.string :via
      t.text :description
      t.string :status
      t.datetime :date
      t.string :phone

      t.timestamps
    end
  end
end
