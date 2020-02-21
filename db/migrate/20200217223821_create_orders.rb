class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :code
      t.string :status
      t.string :bpmn_instance
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
