class AddColorToWorker < ActiveRecord::Migration[6.0]
  def change
    add_column :workers, :color, :string
  end
end
