class CreateProductSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :product_schedules, id: :uuid do |t|
      t.references :product, null: false, foreign_key: true, type: :uuid
      t.references :schedule, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
