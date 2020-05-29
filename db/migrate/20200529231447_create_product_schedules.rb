class CreateProductSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :product_schedules do |t|
      t.references :product, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
