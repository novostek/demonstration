class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :namespace
      t.json :value

      t.timestamps
    end
  end
end
