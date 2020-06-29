class AddActiveToWorker < ActiveRecord::Migration[6.0]
  def change
    add_column :workers, :active, :boolean, default: true
  end
end
