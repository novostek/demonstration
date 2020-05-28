class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules, id: :uuid do |t|
      t.references :worker, null: false, foreign_key: true, type: :uuid
      t.string :title
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :category
      t.string :color
      t.string :origin
      t.integer :origin_id
      t.string :bpmn_instance

      t.timestamps
    end
  end
end
