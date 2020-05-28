class CreateLaborCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :labor_costs, id: :uuid do |t|
      t.references :worker, null: false, foreign_key: true, type: :uuid
      t.references :schedule, null: false, foreign_key: true, type: :uuid
      t.date :date
      t.decimal :value
      t.string :status

      t.timestamps
    end
  end
end
