class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.references :order, null: false, foreign_key: true
      t.references :worker, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :category
      t.string :color
      t.string :bpmn_instance

      t.timestamps
    end
  end
end
