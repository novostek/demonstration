class AddTimeValueToWorker < ActiveRecord::Migration[6.0]
  def change
    add_column :workers, :time_value, :decimal
  end
end
