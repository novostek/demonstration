class CreateLaborCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :labor_costs do |t|
      t.references :worker, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true
      t.date :date
      t.decimal :value
      t.string :status

      t.timestamps
    end
  end
end
