class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :via
      t.text :description
      t.string :status
      t.datetime :date
      t.string :phone

      t.timestamps
    end
  end
end
