class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings, id: :uuid do |t|
      t.string :namespace
      t.json :value

      t.timestamps
    end
  end
end
