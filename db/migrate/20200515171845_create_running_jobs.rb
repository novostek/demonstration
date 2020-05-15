class CreateRunningJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :running_jobs do |t|
      t.boolean :complete
      t.string :redirect

      t.timestamps
    end
  end
end
