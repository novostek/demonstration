class AddWorkerToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :worker, null: true, foreign_key: true, type: :uuid
  end
end
